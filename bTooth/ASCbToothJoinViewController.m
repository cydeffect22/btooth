//
//  ASCbToothJoinViewController.m
//  bTooth
//
//  Created by Anthony Childers on 5/17/13.
//  Copyright (c) 2013 Anthony Childers. All rights reserved.
//

#import "ASCbToothJoinViewController.h"

@interface ASCbToothJoinViewController ()

@end

@implementation ASCbToothJoinViewController
{
	ASCbToothCrowdClient *crowdClient;
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
- (void)viewDidUnload
{
	[super viewDidUnload];
	self.waitView = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameField.delegate = self;
    self.crowdTable.delegate = self;
    self.crowdTable.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
	if (crowdClient == nil)
	{
        _quitReason = QuitReasonConnectionDropped;
		crowdClient = [[ASCbToothCrowdClient alloc] init];
        crowdClient.delegate = self;
		[crowdClient startSearchingForServersWithSessionID:SESSION_ID];
        
		self.nameField.placeholder = crowdClient.session.displayName;
		[self.crowdTable reloadData];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitButton:(id)sender {
    _quitReason = QuitReasonUserQuit;
	[crowdClient disconnectFromServer];
    [self.delegate joinViewControllerDidCancel:self];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (crowdClient != nil)
		return [[crowdClient availableServers] count];
	else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [crowdClient peerIDForAvailableServerAtIndex:indexPath.row];
	cell.textLabel.text = [crowdClient displayNameForPeerID:peerID];
    
	return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - ASCbToothCrowdClientDelegate

- (void)crowdClient:(ASCbToothCrowdClient *)client serverBecameAvailable:(NSString *)peerID
{
	[self.crowdTable reloadData];
}

- (void)crowdClient:(ASCbToothCrowdClient *)client serverBecameUnavailable:(NSString *)peerID
{
	[self.crowdTable reloadData];
}

- (void)crowdClient:(ASCbToothCrowdClient *)client didDisconnectFromServer:(NSString *)peerID
{
	crowdClient.delegate = nil;
	crowdClient = nil;
	[self.crowdTable reloadData];
	[self.delegate joinViewController:self didDisconnectWithReason:_quitReason];
}

- (void)crowdClient:(ASCbToothCrowdClient *)client didConnectToServer:(NSString *)peerID
{
	NSString *name = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([name length] == 0)
		name = crowdClient.session.displayName;
    
	[self.delegate joinViewController:self startCrowdWithSession:crowdClient.session playerName:name server:peerID];
}

- (void)crowdClientNoNetwork:(ASCbToothCrowdClient *)client
{
	_quitReason = QuitReasonNoNetwork;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
	if (crowdClient != nil)
	{
        [self.view addSubview:self.waitView];
        
		NSString *peerID = [crowdClient peerIDForAvailableServerAtIndex:indexPath.row];
		[crowdClient connectToServerWithPeerID:peerID];
	}
}
@end
