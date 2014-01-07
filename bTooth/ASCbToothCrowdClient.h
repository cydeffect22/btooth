//
//  ASCbToothCrowdClient.h
//  bTooth
//
//  Created by Anthony Childers on 5/17/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASCbToothCrowdClient;

@protocol ASCbToothCrowdClientDelegate <NSObject>
- (void)crowdClient:(ASCbToothCrowdClient *)client serverBecameAvailable:(NSString *)peerID;
- (void)crowdClient:(ASCbToothCrowdClient *)client serverBecameUnavailable:(NSString *)peerID;
- (void)crowdClient:(ASCbToothCrowdClient *)client didDisconnectFromServer:(NSString *)peerID;
- (void)crowdClientNoNetwork:(ASCbToothCrowdClient *)client;
- (void)crowdClient:(ASCbToothCrowdClient *)client didConnectToServer:(NSString *)peerID;



@end

@interface ASCbToothCrowdClient : NSObject <GKSessionDelegate>

@property (nonatomic, weak) id <ASCbToothCrowdClientDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray *availableServers;
@property (nonatomic, strong, readonly) GKSession *session;

- (void)connectToServerWithPeerID:(NSString *)peerID;

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID;

- (NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index;

- (NSString *)displayNameForPeerID:(NSString *)peerID;

- (void)disconnectFromServer;

@end
