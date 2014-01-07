//
//  ASCbToothJoinViewController.h
//  bTooth
//
//  Created by Anthony Childers on 5/17/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASCbToothCrowdClient.h"

@class ASCbToothJoinViewController;

@protocol ASCbToothJoinViewControllerDelegate <NSObject>

- (void)joinViewControllerDidCancel:(ASCbToothJoinViewController *)controller;

- (void)joinViewController:(ASCbToothJoinViewController *)controller didDisconnectWithReason:(QuitReason)reason;
- (void)joinViewController:(ASCbToothJoinViewController *)controller startCrowdWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;



@end

@interface ASCbToothJoinViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ASCbToothCrowdClientDelegate>

@property (nonatomic, weak) id <ASCbToothJoinViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITableView *crowdTable;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (strong, nonatomic) IBOutlet UIView *waitView;


@end
