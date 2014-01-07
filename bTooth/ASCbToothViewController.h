//
//  ASCbToothViewController.h
//  bTooth
//
//  Created by 3400 mac on 5/6/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASCbToothHostViewController.h"
#import "ASCbToothJoinViewController.h"
#import "ASCbToothCrowdViewController.h"
 

@interface ASCbToothViewController : UIViewController < ASCbToothHostViewControllerDelegate, ASCbToothJoinViewControllerDelegate, ASCbToothCrowdViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *hostButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end
