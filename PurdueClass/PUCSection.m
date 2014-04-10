//
//  PUCSection.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCSection.h"
#import "PUCMeeting.h"
#import "PUCCourse.h"
#import "PUCClassManager.h"

@implementation PUCSection

+ (NSArray *)initWithMultiSections:(NSArray *) sections_raw by:(PUCCourse *)course
{
    NSMutableArray* sections = [[NSMutableArray alloc]init];
    for (NSDictionary * section_raw in sections_raw)
    {
        PUCSection * section = [[PUCSection alloc]init];
        section.crn = [section_raw objectForKey:@"crn"];
        section.number = [section_raw objectForKey:@"number"];
        section.name = [section_raw objectForKey:@"name"];
        NSString * linked_id = [section_raw objectForKey:@"linked_id"];
        if (linked_id != nil)
        {
            section.linked_id = linked_id;
            section.required_linked_id = [section_raw objectForKey:@"required_link_id"];
        }
        section.course = course;
        
        section.meetings = [PUCMeeting initWithMultiMeetings:[section_raw objectForKey:@"meetings"] by:section];
        [[[PUCClassManager getManager]sections] addObject:section];
        [sections addObject:section];
    }
    return sections;
}

- (NSArray *)linkedSections
{
    if (self.linked_id != nil && _linkedSections==nil) {
        _linkedSections = [self getLinkedSections];
    }
    return _linkedSections;
}

- (NSArray *)getLinkedSections
{
    NSMutableArray * linkedSections = [[NSMutableArray alloc]init];
    NSArray * allSections = self.course.sections;
    for (PUCSection* sec in allSections) {
        if ([sec.linked_id isEqualToString: self.required_linked_id]) {
            [linkedSections addObject:sec];
        }
    }
    return linkedSections;
}

@end
