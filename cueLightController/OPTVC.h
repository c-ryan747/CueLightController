//
//  OPTVC.h
//  cueLightController
//
//  Created by Callum Ryan on 13/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MPController.h"

@protocol OPTVCDelegate <NSObject>

@required
- (void)sendNextState;
- (void)speakButtonPressed;

@end

@interface OPTVC : UITableViewCell {
    NSArray *states;
}
@property (        nonatomic) int stateCount;
@property (strong, nonatomic) MCPeerID *peer;
@property (strong, nonatomic) NSMutableArray *audioList;
@property (weak  , nonatomic) id <OPTVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UILabel *opLabel;
@property (weak, nonatomic) IBOutlet UILabel *cue1;
@property (weak, nonatomic) IBOutlet UILabel *cue2;
@property (weak, nonatomic) IBOutlet UILabel *cue3;


- (void)nextState;
- (void)resetState;
@end
