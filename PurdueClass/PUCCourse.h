//
//  PUCCourse.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCSubject.h"

@interface PUCCourse : NSObject

@property (strong, nonatomic) NSString *CNBR;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSArray* sections;
@property (strong, nonatomic) PUCSubject* subject;

+ (NSArray *)initWithMultiCourses:(NSDictionary *) courses_raw by:(PUCSubject *)subject;

@end