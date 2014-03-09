//
//  PUCSchedule.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCCourse.h"

@interface PUCSchedule : NSObject

@property (strong, nonatomic) NSString* type_id;
@property (strong, nonatomic) NSString* type_name;
@property (strong, nonatomic) NSArray* sections;
@property (strong, nonatomic) PUCCourse* course;

- (instancetype)initWithJSON:(id) JSON;
+ (NSArray *)initWithMultiSchedules:(id) JSON;

@end
