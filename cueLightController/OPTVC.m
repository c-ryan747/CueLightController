//
//  OPTVC.m
//  cueLightController
//
//  Created by Callum Ryan on 13/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "OPTVC.h"

@implementation OPTVC
@synthesize peer = _peer, mainButton, cue1, cue2, cue3, opLabel, speakButton;
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        states = @[@{@"colour":[UIColor greenColor] , @"text":@"Get Ready"  , @"flashing":@NO},
                   @{@"colour":[UIColor orangeColor], @"text":@"..."        , @"flashing":@YES},
                   @{@"colour":[UIColor greenColor] , @"text":@"Go"         , @"flashing":@NO},
                   @{@"colour":[UIColor orangeColor], @"text":@"..."        , @"flashing":@YES}];
    }
    return self;
}
- (void)nextState {
    if (self.stateCount >= states.count - 1) {
        self.stateCount = 0;
    } else {
        self.stateCount++;
    }
    [self loadState];
}
- (void)loadState {
    [self.mainButton setTitle:states[self.stateCount][@"text"]   forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.mainButton.backgroundColor = states[self.stateCount][@"colour"];
    } completion:NULL];
}
- (void)resetState {
    self.stateCount = 0;
    
    self.speakButton.backgroundColor = [UIColor orangeColor];
    [self.speakButton setImage:[UIImage imageNamed:@"MicIcon"] forState:UIControlStateNormal];
    self.speakButton.layer.cornerRadius = 10;
    
    [self loadState];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)mainButtonPressed:(id)sender {
    if (self.stateCount == 1 ||self.stateCount == 3) {
        return;
    } else {
        [self nextState];
        [[MPController sharedInstance] sendObject:@"nextState" ToPeers:@[self.peer]];
        
    }
}
- (IBAction)speakButtonPressed:(id)sender {
    AudioController *ac = [AudioController sharedInstance];
    if (ac.canRecord) {
        if (ac.recorder.recording) {
            [ac stop];
            [ac sendToPeer:[MPController sharedInstance].controllerID];
        } else {
            [ac start];
        }
    }
}
@end
