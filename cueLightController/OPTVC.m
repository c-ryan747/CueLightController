//
//  OPTVC.m
//  cueLightController
//
//  Created by Callum Ryan on 13/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "OPTVC.h"

@implementation OPTVC

@synthesize peer = _peer, mainButton = _mainButton, cue1 = _cue1, cue2 = _cue2, cue3 = _cue3, opLabel = _opLabel, speakButton = _speakButton, audioList = _audioList;

#pragma mark - Init
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        states = @[@{@"colour":[UIColor greenColor] , @"text":@"Get Ready"},
                   @{@"colour":[UIColor orangeColor], @"text":@"..."},
                   @{@"colour":[UIColor greenColor] , @"text":@"Go" },
                   @{@"colour":[UIColor orangeColor], @"text":@"..."}];
        self.audioList = [NSMutableArray array];
        
        //  Setup notification responces as blocks
//        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        [center addObserverForName:CLStartedPlaying object:nil queue:nil usingBlock:^(NSNotification *notification) {
//            self.speakButton.enabled = NO;
//        }];
//        [center addObserverForName:CLFinishedPlaying object:nil queue:nil usingBlock:^(NSNotification *notification) {
//            self.speakButton.enabled = YES;
//        }];
//        [center addObserverForName:CLStartedRecording object:nil queue:nil usingBlock:^(NSNotification *notification) {
//            self.speakButton.enabled = NO;
//        }];
//        [center addObserverForName:CLFinishedRecording object:nil queue:nil usingBlock:^(NSNotification *notification) {
//            self.speakButton.enabled = YES;
//        }];
    }
    return self;
}

#pragma mark - State
- (void)nextState {
    //  if end of cycle, reset, else, increment
    if (self.stateCount >= states.count - 1) {
        self.stateCount = 0;
    } else {
        self.stateCount++;
    }
    
    //  Load in new state
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
    
    #warning Not finished
    self.speakButton.backgroundColor = [UIColor orangeColor];
    [self.speakButton setImage:[UIImage imageNamed:@"MicIcon"] forState:UIControlStateNormal];
    self.speakButton.layer.cornerRadius = 10;
    
    [self loadState];
}

#pragma mark - Events
- (IBAction)mainButtonPressed:(id)sender {
    //  if shouldnt progress, exit, else progress state and tell OP
    if (self.stateCount == 1 ||self.stateCount == 3) {
        return;
    } else {
        [self nextState];
        [[MPController sharedInstance] sendObject:@"nextState" ToPeers:@[self.peer]];
        
    }
}

//  tell delegate if needed
- (IBAction)speakButtonPressed:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(speakButtonPressed:)]) {
        [self.delegate speakButtonPressed:self];
    }
}

@end
