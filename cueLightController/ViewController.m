//
//  ViewController.m
//  cueLightController
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  Tableview init
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);

    //  Networking init
    self.mpController = [MPController sharedInstance];
    [self.mpController setupWithName:nil];
    self.mpController.delegate = self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mpController.session.connectedPeers.count;
}

//  Create a new OP cell and populate with data based on index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OPTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"opCell"];
    cell.peer = self.mpController.session.connectedPeers[indexPath.row];
    cell.opLabel.text = cell.peer.displayName;
    [cell resetState];
    
    //  Rounded corners
    cell.mainButton.layer.cornerRadius = 10;
    cell.speakButton.layer.cornerRadius = 10;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

#pragma mark - Communication
- (IBAction)searchForPeer:(id)sender {
    //  if session created, then create browser and present it
    if (self.mpController.session != nil) {
        [self.mpController createBrowser];
        self.mpController.browser.delegate = self;
        
        [self presentViewController:self.mpController.browser
                           animated:YES
                         completion:nil];
    }
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    //  Dismiss on completion
    [self.mpController.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    //  Dismiss on completion
    [self.mpController.browser dismissViewControllerAnimated:YES completion:nil];
}

//  When a new OPs connected, add a row and tell them im the controller
- (void)peerListChanged {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.mpController sendObject:@"imTheController" ToPeers:self.mpController.session.connectedPeers];
}

//  Update the state of the cell repersenting the OP the sent the message
- (void)recievedMessage:(NSString *)data fromPeer:(MCPeerID *)peer {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.mpController.session.connectedPeers indexOfObject:peer] inSection:0];
    OPTVC *cell = (OPTVC *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell nextState];
}

//  Get relevant cell and update text
- (void)recieveNewCues:(NSArray *)cues fromPeer:(MCPeerID *)peer {
    NSInteger cueIndex = [self.mpController.session.connectedPeers indexOfObject:peer];
    //  Check index was valid
    if (cueIndex != NSNotFound) {
        OPTVC *cell = (OPTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cueIndex inSection:0]];
        
        //  Set text
        cell.cue1.text = cues[0];
        cell.cue2.text = cues[1];
        cell.cue3.text = cues[2];
    }
}

//  Add recieved audio to the appropriate cell
- (void)recievedAudioAtURL:(NSURL *)url fromPeer:(MCPeerID *)peer {
    NSInteger index = [self.mpController.session.connectedPeers indexOfObject:peer];
    OPTVC *cell = (OPTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell.audioList addObject:url];
    if (![cell.speakButtonState isEqualToString:@"Recording"] || ![cell.speakButtonState isEqualToString:@"Playing"]) {
        cell.speakButtonState = @"Received";
    }
}



#pragma mark - Timer
- (IBAction)startStopButtonPressed:(UIBarButtonItem *)sender {
    //  Clear timer
    [self.timer invalidate];
    
    // if start, then start timer & enable pause & set title to stop, else clear & dissable pause & set title to start
    if ([sender.title isEqualToString:@"Start"]) {
        //  Call updateClock every second
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateClock) userInfo:nil repeats: YES];
        self.pauseItem.enabled = YES;
        sender.title = @"Stop";
    } else {
        self.secondsPassed = 0;
        self.pauseItem.enabled = NO;
        sender.title = @"Start";
    }
}

//  Clear timer, dissable pause then rename
- (IBAction)pauseItemPressed:(id)sender {
    [self.timer invalidate];
    self.pauseItem.enabled = NO;
    self.startStopItem.title = @"Start";
}

- (void)updateClock {
    //  Format time
    int hours, minutes, seconds;
    self.secondsPassed++;
    hours = self.secondsPassed / 3600;
    minutes = (self.secondsPassed % 3600) / 60;
    seconds = (self.secondsPassed %3600) % 60;
    
    //  Update UI
    self.timerItem.title = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}
@end
