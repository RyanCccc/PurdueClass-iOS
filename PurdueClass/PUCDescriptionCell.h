//
//  PUCDescriptionCell.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface PUCDescriptionCell : UITableViewCell

@property (nonatomic, strong) UILabel* label;
@property (nonatomic)BOOL added;
- (void)addText: (NSString *)text;
- (CGFloat)getCorrectHeight;

@end
