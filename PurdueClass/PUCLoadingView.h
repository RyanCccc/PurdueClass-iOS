//
//  PUCLoadingView.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-4-9.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GmailLikeLoadingView.h"

@interface PUCLoadingView : UIView

@property (strong, nonatomic)GmailLikeLoadingView* gmailLoadingView;
@property (strong, nonatomic)UILabel* label;

- (void)startAnimation;
- (void)stopAnimation;
- (void)addText:(NSString *)text;

@end
