//
//  OPTVC.h
//  cueLightController
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : UITableViewCell subcalss to layout UI for an OP cell
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "MPController.h"

@interface OPTVC : UITableViewCell {
    NSArray *states;
}

//  General
@property int stateCount;
@property (nonatomic) NSString *speakButtonState;
@property MCPeerID *peer;
@property NSMutableArray *audioList;

//  UI
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UILabel *opLabel;
@property (weak, nonatomic) IBOutlet UILabel *cue1;
@property (weak, nonatomic) IBOutlet UILabel *cue2;
@property (weak, nonatomic) IBOutlet UILabel *cue3;

- (void)nextState;
- (void)resetState;

@end
