//
//  ASCbToothHostViewController.m
//  bTooth
//
//  Created by Anthony Childers on 5/17/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import "ASCbToothHostViewController.h"
@interface ASCbToothHostViewController ()

@end

@implementation ASCbToothHostViewController
{
    ASCbToothCrowdServer *crowdServer;
    QuitReason _quitReason;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
	if (crowdServer == nil)
	{
		crowdServer = [[ASCbToothCrowdServer alloc] init];
        crowdServer.delegate = self;
		crowdServer.maxClients = 9;
		[crowdServer startAcceptingConnectionsForSessionID:SESSION_ID];
        
		self.nameField.placeholder = crowdServer.session.displayName;
		[self.playerTable reloadData];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameField.delegate = self;
    self.playerTable.delegate = self;
    self.playerTable.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startAction:(id)sender{
    
    if (crowdServer != nil && [crowdServer connectedClientCount] > 0)
	{
		NSString *name = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([name length] == 0)
			name = crowdServer.session.displayName;
        
		[crowdServer stopAcceptingConnections];
        
		[self.delegate hostViewController:self startCrowdWithSession:crowdServer.session playerName:name clients:crowdServer.connectedClients];
    
	}
}

- (IBAction)exitAction:(id)sender
{
    _quitReason = QuitReasonUserQuit;
	[crowdServer endSession];
    [self.delegate hostViewControllerDidCancel:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (crowdServer != nil)
		return [crowdServer connectedClientCount];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [crowdServer peerIDForConnectedClientAtIndex:indexPath.row];
	cell.textLabel.text = [crowdServer displayNameForPeerID:peerID];
    
	return cell;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - ASCbToothCrowdServerDelegate

- (void)crowdServer:(ASCbToothCrowdServer *)server clientDidConnect:(NSString *)peerID
{
	[self.playerTable reloadData];
}

- (void)crowdServer:(ASCbToothCrowdServer *)server clientDidDisconnect:(NSString *)peerID
{
	[self.playerTable reloadData];
}

- (void)crowdServerSessionDidEnd:(ASCbToothCrowdServer *)server
{
	crowdServer.delegate = nil;
	crowdServer = nil;
	[self.playerTable reloadData];
	[self.delegate hostViewController:self didEndSessionWithReason:_quitReason];
}

- (void)crowdServerNoNetwork:(ASCbToothCrowdServer *)server
{
	_quitReason = QuitReasonNoNetwork;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}
@end
