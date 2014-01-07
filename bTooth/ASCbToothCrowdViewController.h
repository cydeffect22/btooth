//
//  ASCbToothCrowdViewController.h
//  bTooth
//
//  Created by Anthony Childers on 5/18/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ASCbToothCrowdViewController;

@protocol ASCbToothCrowdViewControllerDelegate <NSObject>

- (void)crowdViewController:(ASCbToothCrowdViewController *)controller didQuitWithReason:(QuitReason)reason;

@end

@interface ASCbToothCrowdViewController : UIViewController <UIAlertViewDelegate , GKSessionDelegate>
@property (nonatomic, weak) id <ASCbToothCrowdViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextView *recievedTextView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (nonatomic, assign) BOOL isServer;

- (void)startServerCrowdWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;
- (void)startClientCrowdWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;
- (void)quitCrowdWithReason:(QuitReason)reason;

@end
