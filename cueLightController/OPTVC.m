//
//  OPTVC.m
//  cueLightController
//
//  Created by Callum Ryan on 13/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "OPTVC.h"

@implementation OPTVC

@synthesize peer = _peer, mainButton = _mainButton, cue1 = _cue1, cue2 = _cue2, cue3 = _cue3, opLabel = _opLabel, speakButton = _speakButton, audioList = _audioList, speakButtonState = _speakButtonState;

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
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserverForName:CLFinishedPlaying object:nil queue:nil usingBlock:^(NSNotification *notification) {
            if ([self.speakButtonState  isEqualToString:@"Playing"]) {
                if (self.audioList.count > 0) {
                    self.speakButtonState = @"Received";
                } else {
                    self.speakButtonState = @"Normal";
                }
            }
            self.speakButton.enabled = YES;
            self.speakButton.alpha = 1.0;
        }];
        [center addObserverForName:CLStartedRecording object:nil queue:nil usingBlock:^(NSNotification *notification) {
            if (![self.speakButtonState  isEqualToString:@"Recording"]) {
                self.speakButton.enabled = NO;
                self.speakButton.alpha = 0.2;
            }
        }];
        [center addObserverForName:CLStartedPlaying object:nil queue:nil usingBlock:^(NSNotification *notification) {
            if (![self.speakButtonState  isEqualToString:@"Playing"]) {
                self.speakButton.enabled = NO;
                self.speakButton.alpha = 0.2;
            }
        }];
        [center addObserverForName:CLFinishedRecording object:nil queue:nil usingBlock:^(NSNotification *notification) {
            self.speakButton.enabled = YES;
            self.speakButton.alpha = 1.0;
        }];
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
    [self loadState];
    
    self.speakButtonState = @"Normal";
}

- (void)changeColour:(UIColor *)colour ofViews:(NSArray *)views animated:(BOOL)animated {
    //  if animated, perform with animation, else just change
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            //  loop through changing colour
            for (UIView *view in views) {
                view.layer.backgroundColor = colour.CGColor;
            }
        } completion:NULL];
    } else {
        //  loop through changing colour
        for (UIView *view in views) {
            view.layer.backgroundColor = colour.CGColor;
        }
    }
}

- (void)setSpeakButtonState:(NSString *)speakButtonState {
    _speakButtonState = speakButtonState;
    if ([speakButtonState isEqualToString:@"Normal"]) {
        [self changeColour:[UIColor greenColor] ofViews:@[self.speakButton] animated:YES];
        [self.speakButton setTitle:nil   forState:UIControlStateNormal];
        [self.speakButton setImage:[UIImage imageNamed:@"MicIcon"] forState:UIControlStateNormal];
    } else if ([speakButtonState isEqualToString:@"Recording"]) {
        [self changeColour:[UIColor orangeColor] ofViews:@[self.speakButton] animated:YES];
        [self.speakButton setTitle:@"..."   forState:UIControlStateNormal];
        [self.speakButton setImage:nil forState:UIControlStateNormal];
    } else if ([speakButtonState isEqualToString:@"Received"]) {
        [self changeColour:[UIColor redColor] ofViews:@[self.speakButton] animated:YES];
        [self.speakButton setTitle:nil   forState:UIControlStateNormal];
        [self.speakButton setImage:[UIImage imageNamed:@"SpeakerIcon"] forState:UIControlStateNormal];
    } else if ([speakButtonState isEqualToString:@"Playing"]) {
        [self changeColour:[UIColor orangeColor] ofViews:@[self.speakButton] animated:YES];
        [self.speakButton setTitle:@"..."   forState:UIControlStateNormal];
        [self.speakButton setImage:nil forState:UIControlStateNormal];
    }
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
    AudioController *ac = [AudioController sharedInstance];
    
    if (ac.recorder.recording) {
        if (self.audioList.count > 0) {
            self.speakButtonState = @"Received";
        } else {
            self.speakButtonState = @"Normal";
        }
        
        [ac stop];
        [ac sendToPeer:self.peer];
    } else if (ac.player.playing) {
        if (self.audioList.count > 0) {
            self.speakButtonState = @"Received";
        } else {
            self.speakButtonState = @"Normal";
        }
        
        [ac.player stop];
    } else if ([self.speakButtonState isEqualToString:@"Normal"]) {
        self.speakButtonState = @"Recording";
        
        [ac start];
    } else if ([self.speakButtonState isEqualToString:@"Received"]) {
        self.speakButtonState = @"Playing";
        
        [ac playUrl:self.audioList[0]];
        [self.audioList removeObjectAtIndex:0];
    }
}

@end
