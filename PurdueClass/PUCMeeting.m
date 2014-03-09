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

- (instancetype)initWithJSON:(id) JSON
{
    self = [super init];
    
    if(self){
        NSDictionary * meeting = (NSDictionary *)JSON;
        self.DayOfWeek = [meeting objectForKey:@"DayOfWeek"];
        self.instructor = [meeting objectForKey:@"instructor"];
        self.building = [meeting objectForKey:@"building"];
        self.room = [meeting objectForKey:@"room"];
        self.start_t = [[meeting objectForKey:@"start_t"]integerValue];
        self.end_t = [[meeting objectForKey:@"end_t"]integerValue];
        PUCClassManager * mng = [PUCClassManager getManager];
        [mng.meetings addObject:self];
    }
    return self;
}

+ (NSArray *)initWithMultiMeetings:(id) JSON
{
    NSArray * meetings_JSON = (NSArray *)JSON;
    NSMutableArray * meetings = [[NSMutableArray alloc]init];
    for (id meeting in meetings_JSON)
    {
        [meetings addObject:[[PUCMeeting alloc]initWithJSON:meeting]];
    }
    return meetings;
}

@end
