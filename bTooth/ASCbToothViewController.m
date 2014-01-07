//
//  ASCbToothViewController.m
//  bTooth
//
//  Created by 3400 mac on 5/6/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import "ASCbToothViewController.h"



@interface ASCbToothViewController ()

@end


@implementation ASCbToothViewController

- (IBAction)startJoin:(id)sender {
    ASCbToothJoinViewController *controller = [[ASCbToothJoinViewController alloc] initWithNibName:nil bundle:nil];
    controller.delegate = self;
    [self presentViewController:controller animated:NO completion:nil];}

- (IBAction)startHost:(id)sender {
    ASCbToothHostViewController *controller = [[ASCbToothHostViewController alloc] initWithNibName:nil bundle:nil];
    controller.delegate = self;    
    [self presentViewController:controller animated:NO completion:nil];
}

- (void)showDisconnectedAlert
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Disconnected", @"Client disconnected alert title")
                              message:NSLocalizedString(@"You were disconnected from the game.", @"Client disconnected alert message")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
                              otherButtonTitles:nil];
    
	[alertView show];
}

- (void)showNoNetworkAlert
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"No Network", @"No network alert title")
                              message:NSLocalizedString(@"Please enable Bluetooth or Wi-Fi in your device's Settings.", @"No network alert message")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
                              otherButtonTitles:nil];
    
	[alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ASCbToothCrowdViewController *)startCrowd
{
	ASCbToothCrowdViewController *crowdViewController = [[ASCbToothCrowdViewController alloc] initWithNibName:nil bundle:nil];
	crowdViewController.delegate = self;
    
	[self presentViewController:crowdViewController animated:NO completion:nil];
    return crowdViewController;
}

#pragma mark - HostViewControllerDelegate

- (void)hostViewController:(ASCbToothHostViewController *)controller startCrowdWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients
{
    
	[self dismissViewControllerAnimated:NO completion:nil];
    ASCbToothCrowdViewController * crowdViewController = [self startCrowd];
    [crowdViewController startServerCrowdWithSession:session playerName:name clients:clients];
}

- (void)hostViewControllerDidCancel:(ASCbToothHostViewController *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
}

- (void)hostViewController:(ASCbToothHostViewController *)controller didEndSessionWithReason:(QuitReason)reason
{
	if (reason == QuitReasonNoNetwork)
	{
		[self showNoNetworkAlert];
	}
}

#pragma mark - JoinViewControllerDelegate

- (void)joinViewControllerDidCancel:(ASCbToothJoinViewController *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
}

- (void)joinViewController:(ASCbToothJoinViewController *)controller didDisconnectWithReason:(QuitReason)reason
{
    if (reason == QuitReasonNoNetwork)
	{
		[self showNoNetworkAlert];
	}
	else if (reason == QuitReasonConnectionDropped)
	{
		[self dismissViewControllerAnimated:NO completion:^
         {
             [self showDisconnectedAlert];
         }];
	}
}

- (void)joinViewController:(ASCbToothJoinViewController *)controller startCrowdWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID
{
    [self dismissViewControllerAnimated:NO completion:nil];
    ASCbToothCrowdViewController * crowdViewController = [self startCrowd];
    [crowdViewController startClientCrowdWithSession:session playerName:name server:peerID];
          
}

#pragma mark - CrowdViewControllerDelegate

- (void)crowdViewController:(ASCbToothCrowdViewController *)controller didQuitWithReason:(QuitReason)reason
{
	[self dismissViewControllerAnimated:NO completion:^
     {
         if (reason == QuitReasonConnectionDropped)
         {
             [self showDisconnectedAlert];
         }
     }];
}

@end
