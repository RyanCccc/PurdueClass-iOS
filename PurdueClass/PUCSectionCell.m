//
//  PUCSectionCell.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCSectionCell.h"

@implementation PUCSectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    if (self) {
        // Initialization code
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 140, 15)];
        self.downLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 140, 15)];
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-150, 5, 140, 15)];
        self.downRightLabel = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-150, 25, 140, 15)];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.downRightLabel.textAlignment = NSTextAlignmentRight;
        
        self.downLeftLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:10.0];
        self.downRightLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:10.0];
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.downRightLabel];
        [self.contentView addSubview:self.downLeftLabel];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 140, 15)];
        self.downLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 140, 15)];
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-150, 5, 140, 15)];
        self.downRightLabel = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-150, 25, 140, 15)];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.downRightLabel.textAlignment = NSTextAlignmentRight;
        
        self.downLeftLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:10.0];
        self.downRightLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:10.0];
        
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.downRightLabel];
        [self addSubview:self.downLeftLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
