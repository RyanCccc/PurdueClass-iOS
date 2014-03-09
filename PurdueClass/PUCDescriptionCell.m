//
//  PUCDescriptionCell.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCDescriptionCell.h"



@implementation PUCDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.label setLineBreakMode:NSLineBreakByWordWrapping];
        [self.label setNumberOfLines:0];
        [self.label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [self.label setTag:1];

        [[self contentView] addSubview:self.label];
        self.added = NO;
    }
    return self;
}

- (void)addText: (NSString *)text
{
    if (!self.added){
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        [self.label setText:text];
        [self.label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
        self.added = YES;
    }
}

- (CGFloat)getCorrectHeight
{
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 4), 20000.0f);
    CGSize size = [self.label.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return  MAX(size.height, 44.0f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
