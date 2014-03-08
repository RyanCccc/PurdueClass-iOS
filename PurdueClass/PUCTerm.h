//
//  PUCTerm.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUCTerm : NSObject

@property (nonatomic) NSInteger *code;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSArray *courses;

@end
