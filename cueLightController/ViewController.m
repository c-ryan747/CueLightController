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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);

    self.mpController = [MPController sharedInstance];
    [self.mpController setupIfNeeded];
    self.mpController.delegate = self;
    
    [self.tableView registerClass:[OPTVC class] forCellReuseIdentifier:@"opCell"];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.mpController.session.connectedPeers.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OPTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"opCell"];
    
    for (int i=0; i<cell.cueLables.count; i++) {
        UILabel *label = (UILabel *)cell.cueLables[i];
        label.text = [NSString stringWithFormat:@"%d.    Some Cell descriptor",i+1];
    }
    
    [cell.mainButton setTitle:@"Ready" forState:UIControlStateNormal];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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

- (IBAction)testMessage:(id)sender {
    NSArray *peers = [self.mpController.session connectedPeers];
    if (peers.count > 0) {
        [self.mpController.session sendData:[@"hello" dataUsingEncoding:NSUTF8StringEncoding] toPeers:peers withMode:MCSessionSendDataReliable error:nil];
    }
}
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self.mpController.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.mpController.browser dismissViewControllerAnimated:YES completion:nil];
}
- (void)peerListChanged
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
