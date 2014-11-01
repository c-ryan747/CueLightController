//
//  ViewController.h
//  cueLightController
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : UIViewController for handling the UI in the main view
//

#import <UIKit/UIKit.h>

#import "MPController.h"
#import "OPTVC.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MCBrowserViewControllerDelegate, MPControllerDelegate, OPTVCDelegate>

@property (strong, nonatomic) MPController *mpController;

//  Timer properties
@property (strong, nonatomic) NSTimer *timer;
@property (        nonatomic) int secondsPassed;

//  References to UI elements
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (weak,   nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *timerItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pauseItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startStopItem;

- (IBAction)searchForPeer:(id)sender;

@end

