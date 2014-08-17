//
//  ViewController.h
//  cueLightController
//
//  Created by Callum Ryan on 11/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPController.h"
#import "OPTVC.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MCBrowserViewControllerDelegate, MPControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MPController *mpController;
- (IBAction)searchForPeer:(id)sender;


@end

