//
//  ASCbToothCrowdServer.h
//  bTooth
//
//  Created by Anthony Childers on 5/17/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASCbToothCrowdServer;

@protocol ASCbToothCrowdServerDelegate <NSObject>

- (void)crowdServer:(ASCbToothCrowdServer *)server clientDidConnect:(NSString *)peerID;
- (void)crowdServer:(ASCbToothCrowdServer *)server clientDidDisconnect:(NSString *)peerID;
- (void)crowdServerSessionDidEnd:(ASCbToothCrowdServer *)server;
- (void)crowdServerNoNetwork:(ASCbToothCrowdServer *)server;


@end

@interface ASCbToothCrowdServer : NSObject<GKSessionDelegate>

@property (nonatomic, assign) int maxClients;
@property (nonatomic, strong, readonly) NSArray *connectedClients;
@property (nonatomic, strong, readonly) GKSession *session;
@property (nonatomic, weak) id <ASCbToothCrowdServerDelegate> delegate;

- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID;

- (void)stopAcceptingConnections;

- (NSUInteger)connectedClientCount;

- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index;

- (NSString *)displayNameForPeerID:(NSString *)peerID;

- (void)endSession;

@end
