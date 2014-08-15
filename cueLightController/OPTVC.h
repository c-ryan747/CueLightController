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


@interface OPTVC : UITableViewCell
@property (strong, nonatomic) UIButton *mainButton;
@property (strong, nonatomic) NSMutableArray *cueLables;
@property (strong, nonatomic) MCPeerID *peer;

@end
