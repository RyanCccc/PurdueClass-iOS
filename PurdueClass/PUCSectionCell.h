//
//  PUCSectionCell.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface PUCSectionCell : SWTableViewCell

@property (strong, nonatomic)UILabel * leftLabel;
@property (strong, nonatomic)UILabel * downLeftLabel;
@property (strong, nonatomic)UILabel * rightLabel;
@property (strong, nonatomic)UILabel * downRightLabel;
@property (strong, nonatomic)NSString *crn;

@end