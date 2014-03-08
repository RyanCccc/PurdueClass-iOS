//
//  PUCSection.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCSchedule.h"

@interface PUCSection : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* number;
@property (strong, nonatomic) NSString* crn;
@property (strong, nonatomic) NSArray *linked_sections;
@property (strong, nonatomic) NSArray* meetings;
@property (strong, nonatomic) PUCSchedule* schedule;

@end
