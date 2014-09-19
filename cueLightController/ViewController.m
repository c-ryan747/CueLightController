//
//  ViewController.m
//  cueLightController
//
//  Created by Callum Ryan on 11/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);

    self.mpController = [MPController sharedInstance];
    [self.mpController setupIfNeededWithName:nil];
    self.mpController.delegate = self;
    
    //[self.tableView registerClass:[OPTVC class] forCellReuseIdentifier:@"opCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.mpController.session.connectedPeers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OPTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"opCell"];
    cell.peer = self.mpController.session.connectedPeers[indexPath.row];
    cell.opLabel.text = cell.peer.displayName;
    cell.mainButton.layer.cornerRadius = 10;
    [cell resetState];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (IBAction)searchForPeer:(id)sender {
    if (self.mpController.session != nil) {
        [self.mpController createBrowser];
        self.mpController.browser.delegate = self;
        
        [self presentViewController:self.mpController.browser
                           animated:YES
                         completion:nil];
    }
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self.mpController.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.mpController.browser dismissViewControllerAnimated:YES completion:nil];
}
- (void)peerListChanged {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.mpController sendObject:@"imTheController" ToPeers:self.mpController.session.connectedPeers];
}
- (void)recievedMessage:(NSData *)data fromPeer:(MCPeerID *)peer {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.mpController.session.connectedPeers indexOfObject:peer] inSection:0];
    OPTVC *cell = (OPTVC *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell nextState];
}
- (void)recieveNewCues:(NSArray *)cues fromPeer:(MCPeerID *)peer {
    NSInteger cueIndex = [self.mpController.session.connectedPeers indexOfObject:peer];
    if (cueIndex != NSNotFound) {
        OPTVC *cell = (OPTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cueIndex inSection:0]];
        cell.cue1.text = cues[0];
        cell.cue2.text = cues[1];
        cell.cue3.text = cues[2];
    }
    
}

- (void)recievedAudioAtURL:(NSURL *)url fromPeer:(MCPeerID *)peer {
    NSInteger index = [self.mpController.session.connectedPeers indexOfObject:peer];
    OPTVC *cell = (OPTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell.audioList addObject:url];
}
@end
