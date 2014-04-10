//
//  PUCSection.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCCourse.h"

@interface PUCSection : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* number;
@property (strong, nonatomic) NSString* crn;
@property (strong, nonatomic) NSString* linked_id;
@property (strong, nonatomic) NSString* required_linked_id;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* time;
@property (strong, nonatomic) NSArray* linkedSections;

@property (strong, nonatomic) NSArray* meetings;
@property (strong, nonatomic) PUCCourse* course;

+ (NSArray *)initWithMultiSections:(NSArray *) sections_raw by:(PUCCourse *)course;

@end
