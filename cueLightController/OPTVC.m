//
//  OPTVC.m
//  cueLightController
//
//  Created by Callum Ryan on 13/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "OPTVC.h"

@implementation OPTVC
@synthesize mainButton = _mainButton, cueLables = _cueLables, peer = _peer;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cueLables = [NSMutableArray array];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.mainButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.mainButton.frame = CGRectMake(20, 10, 100, 80);
        self.mainButton.backgroundColor = [UIColor greenColor];
        
        [self.mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.mainButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        
        [self.mainButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.mainButton.layer.cornerRadius = 10;
        
        [self addSubview:self.mainButton];
        
        for (int i=0; i<3; i++) {
            UILabel *cueLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 10 + i*30, 400, 20)];
            [self.cueLables addObject:cueLabel];
            [self addSubview:cueLabel];
        }
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buttonPressed:(id)sender
{
    [[MPController sharedInstance] sendString:@"nextState" ToPeers:[NSArray arrayWithObject:self.peer]];
}
@end
