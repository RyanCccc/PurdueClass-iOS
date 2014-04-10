//
//  PUCMeeting.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCMeeting.h"
#import "PUCClassManager.h"

@implementation PUCMeeting

+ (NSArray *)initWithMultiMeetings:(NSArray *)meetings_raw by:(PUCSection *)section
{
    NSMutableArray* meetings = [[NSMutableArray alloc]init];
    for (NSDictionary* meeting_raw in meetings_raw) {
        PUCMeeting * meeting = [[PUCMeeting alloc]init];
        meeting.days = [meeting_raw objectForKey:@"days"];
        meeting.date = [meeting_raw objectForKey:@"date"];
        meeting.instructor = [meeting_raw objectForKey:@"instructor"];
        meeting.location = [meeting_raw objectForKey:@"location"];
        meeting.time = [[meeting_raw objectForKey:@"time"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        meeting.type = [meeting_raw objectForKey:@"type"];
        meeting.section = section;
        if (section.type == nil) {
            section.type = meeting.type;
        }
        if (section.time == nil) {
            section.time = meeting.time;
        }else
        {
            if (![section.time isEqualToString:meeting.time]) {
                section.time = @"Multiple Time";
            }
        }
        [[[PUCClassManager getManager]meetings] addObject:meeting];
        [meetings addObject:meeting];
    }
    return meetings;
}

@end
