//
//  ASCbToothHostViewController.h
//  bTooth
//
//  Created by Anthony Childers on 5/17/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "ASCbToothCrowdServer.h"

@class ASCbToothHostViewController;

@protocol ASCbToothHostViewControllerDelegate <NSObject>

- (void)hostViewController:(ASCbToothHostViewController *)controller startCrowdWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;
- (void)hostViewControllerDidCancel:(ASCbToothHostViewController *)controller;
- (void)hostViewController:(ASCbToothHostViewController *)controller didEndSessionWithReason:(QuitReason)reason;


@end

@interface ASCbToothHostViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,ASCbToothCrowdServerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITableView *playerTable;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (nonatomic, weak) id
<ASCbToothHostViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@end
