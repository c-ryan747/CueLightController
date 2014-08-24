//
//  OPTVC.m
//  cueLightController
//
//  Created by Callum Ryan on 13/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "OPTVC.h"

@implementation OPTVC
@synthesize mainButton = _mainButton, cueLables = _cueLables, peer = _peer, opLable = _opLable;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        states = @[@{@"colour":[UIColor greenColor] , @"text":@"Get Ready"  , @"flashing":@NO},
                   @{@"colour":[UIColor orangeColor], @"text":@"..."        , @"flashing":@YES},
                   @{@"colour":[UIColor greenColor] , @"text":@"Go"         , @"flashing":@NO},
                   @{@"colour":[UIColor orangeColor], @"text":@"..."        , @"flashing":@YES}];
        self.stateCount = 0;
        
        self.cueLables = [NSMutableArray array];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mainButton.frame = CGRectMake(20, 10, 100, 80);
        self.mainButton.backgroundColor = states[self.stateCount][@"colour"];
        
        [self.mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.mainButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        
        [self.mainButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.mainButton.layer.cornerRadius = 10;
        
        [self addSubview:self.mainButton];
        
        
        self.opLable = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, 400, 80)];
        self.opLable.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.opLable];
        
        
        for (int i=0; i<3; i++) {
            UILabel *cueLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 10 + i*30, 400, 20)];
            [self.cueLables addObject:cueLabel];
            [self addSubview:cueLabel];
        }
    }
    return self;
}

- (void)nextState
{
    if (self.stateCount >= states.count - 1) {
        self.stateCount = 0;
    } else {
        self.stateCount++;
    }
    [self loadState];
}
- (void)loadState
{
    [self.mainButton setTitle:states[self.stateCount][@"text"]   forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.mainButton.backgroundColor = states[self.stateCount][@"colour"];
    } completion:NULL];
}
- (void)resetState
{
    self.stateCount = 0;
    [self loadState];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buttonPressed:(id)sender
{
    if (self.stateCount == 1 ||self.stateCount == 3) {
        return;
    } else {
        [self nextState];
        [[MPController sharedInstance] sendObject:@"nextState" ToPeers:@[self.peer]];
        
    }
}
@end
