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

@class OPTVC;

//  Protocol to get data from cell
@protocol OPTVCDelegate <NSObject>

- (void)speakButtonPressed:(OPTVC *)sender;

@end


@interface OPTVC : UITableViewCell {
    NSArray *states;
}

//  General
@property (        nonatomic) int stateCount;
@property (strong, nonatomic) MCPeerID *peer;
@property (strong, nonatomic) NSMutableArray *audioList;
@property (weak  , nonatomic) id <OPTVCDelegate> delegate;

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
