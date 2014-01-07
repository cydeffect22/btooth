//
//  ASCbToothCrowdViewController.m
//  bTooth
//
//  Created by Anthony Childers on 5/18/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import "ASCbToothCrowdViewController.h"

@interface ASCbToothCrowdViewController ()

@end

@implementation ASCbToothCrowdViewController
{
    GKSession *_session;
    NSString *_serverPeerID;
    NSString *_localPlayerName;
    int overWrite;
    
}

- (IBAction)sendButtonPressed:(id)sender {
    //package text field text as NSData object
     NSData *textData = [self.sendTextField.text dataUsingEncoding:NSASCIIStringEncoding];
    //send data to all connected devices
    [_session sendDataToAllPeers: textData withDataMode:GKSendDataReliable error:nil];
    self.sendTextField.text = @"";
    [self.view endEditing:YES];
     CGRect view_Frame = CGRectMake(0.0f, 18.0f, 320.0f, 460.0f);
    [self.view setFrame:view_Frame];
}


- (IBAction)editingBegan:(id)sender {
    CGRect view_Frame = CGRectMake(0.0f, 18.0f, 320.0f, 250.0f);
    [self.view setFrame:view_Frame ];}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    overWrite = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitAction:(id)sender
{
	[self quitCrowdWithReason:QuitReasonUserQuit];
}

#pragma mark - Crowd Logic

- (void)startClientCrowdWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID
{
    self.isServer = NO;
    
	_session = session;
	_session.available = NO;
	_session.delegate = self;
    [_session setDataReceiveHandler:self withContext:nil];
    
	_serverPeerID = peerID;
	_localPlayerName = name;
    
}

- (void)startServerCrowdWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients
{
	self.isServer = YES;
    
	_session = session;
	_session.available = NO;
	_session.delegate = self;
	[_session setDataReceiveHandler:self withContext:nil];
    
}

- (void)quitCrowdWithReason:(QuitReason)reason
{
    [_session disconnectFromAllPeers];
    _session.delegate = nil;
	_session = nil;
    
	[self.delegate crowdViewController: self didQuitWithReason:reason];
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"Game: peer %@ changed state %d", peerID, state);
#endif
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"Game: connection request from peer %@", peerID);
#endif
    
	[session denyConnectionFromPeer:peerID];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: connection with peer %@ failed %@", peerID, error);
#endif
    
	// Not used.
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: session failed %@", error);
#endif
    
    QuitReason reason = QuitReasonConnectionDropped;
    
    [self.delegate crowdViewController:self didQuitWithReason:reason];
    
}

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
    #ifdef DEBUG
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
    #endif
    
        NSString *newLine = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
    if (overWrite)
    {
        self.recievedTextView.text = newLine;
        overWrite = 0;
    }
    else
    {
        NSString *oldLine = self.recievedTextView.text;
        self.recievedTextView.text = [NSString stringWithFormat:@"%@\n%@", oldLine, newLine];
    }
}


@end
