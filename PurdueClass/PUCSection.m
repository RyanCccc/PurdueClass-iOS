//
//  PUCSection.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCSection.h"
#import "PUCMeeting.h"
#import "PUCClassManager.h"

@implementation PUCSection

- (instancetype)initWithJSON:(id) JSON forLinkedSection:(BOOL) forLinked
{
    self = [super init];
    
    if(self){
        NSDictionary * section = (NSDictionary *)JSON;
        self.name = [section objectForKey:@"name"];
        self.number = [section objectForKey:@"number"];
        self.crn = [section objectForKey:@"crn"];
        self.meetings = [PUCMeeting initWithMultiMeetings:[section objectForKey:@"meetings"]];
        self.linked_sections = [PUCSection initWithLinkedSections:[section objectForKey:@"linked_sections"]];
        for (PUCMeeting* meeting in self.meetings)
        {
            meeting.section = self;
        }
        self.start_t = ((PUCMeeting*)self.meetings[0]).start_t;
        self.end_t = ((PUCMeeting*)self.meetings[0]).end_t;
        if (!forLinked) {
            PUCClassManager * mng = [PUCClassManager getManager];
            [mng.sections addObject:self];
        }
    }
    return self;
}

+ (NSArray *)initWithMultiSections:(id) JSON
{
    NSMutableArray * sections = [[NSMutableArray alloc]init];
    NSArray* sections_JSON = (NSArray*)JSON;
    for (NSArray* section_JSON in sections_JSON)
    {
        [sections addObject:[[PUCSection alloc]initWithJSON:section_JSON forLinkedSection:false]];
    }
    return sections;
}

+ (NSArray *)initWithLinkedSections:(id) JSON
{
    NSMutableArray * sections = [[NSMutableArray alloc]init];
    NSArray* multi_sections_JSON = (NSArray*)JSON;
    for (NSArray* sections_JSON in multi_sections_JSON)
    {
        NSMutableArray * section_set = [[NSMutableArray alloc]init];
        for (id section in sections_JSON)
        {
            [section_set addObject:[[PUCSection alloc]initWithJSON:section forLinkedSection:true]];
        }
        [sections addObject:[section_set copy]];
    }
    return sections;
}

@end
