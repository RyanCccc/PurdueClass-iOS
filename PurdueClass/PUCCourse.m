//
//  PUCCourse.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCCourse.h"
#import "PUCSubject.h"
#import "PUCSection.h"
#import "PUCClassManager.h"

@implementation PUCCourse

+ (NSArray *)initWithMultiCourses:(NSDictionary *) courses_raw by:(PUCSubject *)subject
{
    NSMutableArray * courses = [[NSMutableArray alloc]init];
    for (id key in courses_raw) {
        PUCCourse * course = [[PUCCourse alloc]init];
        NSDictionary * course_raw = [courses_raw objectForKey:key];
        course.name = [course_raw objectForKey:@"name"];
        course.CNBR = key;
        course.description = @"NONE";
        course.subject = subject;
        course.sections = [PUCSection initWithMultiSections:[course_raw objectForKey:@"sections"] by:course];
        [[[PUCClassManager getManager]courses] addObject:course];
        [courses addObject:course];
    }
    return courses;
}

@end