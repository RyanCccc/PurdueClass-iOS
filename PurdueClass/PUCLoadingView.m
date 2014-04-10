//
//  PUCLoadingView.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-4-9.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCLoadingView.h"


@implementation PUCLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.gmailLoadingView = [[GmailLikeLoadingView alloc] initWithFrame:CGRectMake(50, 0, 60, 60)];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 160, 60)];
        [self.label setLineBreakMode:NSLineBreakByWordWrapping];
        [self.label setNumberOfLines:0];
        [self.label setFont:[UIFont systemFontOfSize:12.0f]];
        [self addSubview:self.gmailLoadingView];
        [self addSubview:self.label];
    }
    return self;
}

- (void)addText:(NSString *)text
{
    self.label.text = text;
}

- (void)stopAnimation
{
    [self.gmailLoadingView stopAnimating];
    [self setHidden:YES];
}

- (void)startAnimation
{
    [self setHidden:NO];
    [self.gmailLoadingView startAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
