//
//  PUCSchedule.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCSchedule.h"
#import "PUCSection.h"
#import "PUCClassManager.h"

@implementation PUCSchedule

- (instancetype)initWithJSON:(id) JSON
{
    self = [super init];
    
    if(self){
        NSDictionary * schedule = (NSDictionary *)JSON;
        self.type_id = [schedule objectForKey:@"type_id"];
        self.type_name = [schedule objectForKey:@"type_name"];
        self.sections = [PUCSection initWithMultiSections:[schedule objectForKey:@"sections"]];
        for (PUCSection* section in self.sections)
        {
            section.schedule = self;
        }
        PUCClassManager * mng = [PUCClassManager getManager];
        [mng.schedules addObject:self];
    }
    return self;
}

+ (NSArray *)initWithMultiSchedules:(id) JSON
{
    NSArray * schedules_JSON = (NSArray *)JSON;
    NSMutableArray * schedules = [[NSMutableArray alloc]init];
    for (id schedule in schedules_JSON)
    {
        [schedules addObject:[[PUCSchedule alloc]initWithJSON:schedule]];
    }
    return schedules;
}

@end
