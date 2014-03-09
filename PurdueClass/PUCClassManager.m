//
//  PUCClassFactory.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-7.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCClassManager.h"
#import "PUCCourse.h"

static PUCClassManager* me;

@implementation PUCClassManager

+ (PUCClassManager *)getManager
{
    if (me==nil) {
        me = [[PUCClassManager alloc]init];
        me.schedules = [[NSMutableArray alloc]init];
        me.sections = [[NSMutableArray alloc]init];
        me.meetings = [[NSMutableArray alloc]init];
    }
    return me;
}

- (void) getCourse:(id)JSON
{
    me.course = [[PUCCourse alloc]initWithJSON:JSON];
}

- (void) clearCourse
{
    me.course = nil;
    [me.schedules removeAllObjects];
    [me.sections removeAllObjects];
    [me.meetings removeAllObjects];
}

@end
