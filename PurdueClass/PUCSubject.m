//
//  PUCSubject.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-28.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCSubject.h"
#import "PUCCourse.h"

@implementation PUCSubject

- (instancetype)initWith:(NSArray *) subject_raw
{
    self = [super init];
    
    if(self){
        self.subject = [subject_raw objectAtIndex:0];
        self.subject_name = [subject_raw objectAtIndex:1];
        NSDictionary * courses = [subject_raw objectAtIndex:2];
        self.courses = [PUCCourse initWithMultiCourses:courses by:self];
    }
    return self;
}

+ (NSMutableArray *)initWithMultiSubjects:(NSArray *) subjects_raw
{
    NSMutableArray * subjects = [[NSMutableArray alloc]init];
    for (NSArray* subject_raw in subjects_raw) {
        PUCSubject * subject = [[PUCSubject alloc]initWith:subject_raw];
        [subjects addObject:subject];
    }
    return subjects;
}

@end
