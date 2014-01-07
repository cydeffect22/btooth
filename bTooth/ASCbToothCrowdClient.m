//
//  ASCbToothCrowdClient.m
//  bTooth
//
//  Created by Anthony Childers on 5/17/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import "ASCbToothCrowdClient.h"

typedef enum
{
	ClientStateIdle,
	ClientStateSearchingForServers,
	ClientStateConnecting,
	ClientStateConnected,
}
ClientState;

@implementation ASCbToothCrowdClient
{
	NSMutableArray *_availableServers;
    ClientState _clientState;
    NSString *_serverPeerID;
}

- (id)init
{
	if ((self = [super init]))
	{
		_clientState = ClientStateIdle;
	}
	return self;
}

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID
{
    if (_clientState == ClientStateIdle)
	{
		_clientState = ClientStateSearchingForServers;
		_availableServers = [NSMutableArray arrayWithCapacity:10];
        
        _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
        _session.delegate = self;
        _session.available = YES;
	}
	
}

- (NSArray *)availableServers
{
	return _availableServers;
}

- (NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index
{
	return [_availableServers objectAtIndex:index];
}

- (NSString *)displayNameForPeerID:(NSString *)peerID
{
	return [_session displayNameForPeer:peerID];
}

- (void)connectToServerWithPeerID:(NSString *)peerID
{
	NSAssert(_clientState == ClientStateSearchingForServers, @"Wrong state");
    
	_clientState = ClientStateConnecting;
	_serverPeerID = peerID;
	[_session connectToPeer:peerID withTimeout:_session.disconnectTimeout];
}

- (void)disconnectFromServer
{
	NSAssert(_clientState != ClientStateIdle, @"Wrong state");
    
	_clientState = ClientStateIdle;
    
	[_session disconnectFromAllPeers];
	_session.available = NO;
	_session.delegate = nil;
	_session = nil;
    
	_availableServers = nil;
    
	[self.delegate crowdClient:self didDisconnectFromServer:_serverPeerID];
	_serverPeerID = nil;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"CrowdClient: peer %@ changed state %d", peerID, state);
#endif
    
    switch (state)
	{
            // The client has discovered a new server.
        
        case GKPeerStateAvailable:
            if (_clientState == ClientStateSearchingForServers)
			{
                if (![_availableServers containsObject:peerID])
                {
                    [_availableServers addObject:peerID];
                    [self.delegate crowdClient:self serverBecameAvailable:peerID];
                }
			}
			break;
            
            // The client sees that a server goes away.
		case GKPeerStateUnavailable:
            if (_clientState == ClientStateSearchingForServers)
			{
                if ([_availableServers containsObject:peerID])
                {
                    [_availableServers removeObject:peerID];
                    [self.delegate crowdClient:self serverBecameUnavailable:peerID];
                }
			}
            // Is this the server we're currently trying to connect with?
			if (_clientState == ClientStateConnecting && [peerID isEqualToString:_serverPeerID])
			{
				[self disconnectFromServer];
			}
			break;
         // You're now connected to the server.   
		case GKPeerStateConnected:
            if (_clientState == ClientStateConnecting)
			{
                [self.delegate crowdClient:self didConnectToServer:peerID];
				_clientState = ClientStateConnected;
			}
			break;
            
            // You're now no longer connected to the server.
		case GKPeerStateDisconnected:
			if (_clientState == ClientStateConnected)
			{
				[self disconnectFromServer];
			}
			break;
            
		case GKPeerStateConnecting:
			break;
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"CrowdClient: connection request from peer %@", peerID);
#endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"CrowdClient: connection with peer %@ failed %@", peerID, error);
#endif
    
    [self disconnectFromServer];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"CrowdClient: session failed %@", error);
#endif
    
    if ([[error domain] isEqualToString:GKSessionErrorDomain])
	{
		if ([error code] == GKSessionCannotEnableError)
		{
			[self.delegate crowdClientNoNetwork:self];
			[self disconnectFromServer];
		}
	}
}

@end
