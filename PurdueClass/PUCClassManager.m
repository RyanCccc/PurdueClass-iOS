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
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        me.plistPath = [rootPath stringByAppendingPathComponent:@"followList.plist"];
        
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

- (BOOL)writeData:(id)data
{
    NSMutableArray * new_list = nil;
    NSString *error;
    PUCSection * section = (PUCSection *)data;
    NSMutableArray * objects = [[NSMutableArray alloc]init];
    NSMutableDictionary* section_dict = [[NSMutableDictionary alloc]init];
    [section_dict setObject:section.name forKey:@"name"];
    [section_dict setObject:section.number forKey:@"number"];
    [section_dict setObject:section.crn forKey:@"crn"];
    [section_dict setObject:[NSNumber numberWithInteger:section.start_t] forKey:@"start_t"];
    [section_dict setObject:[NSNumber numberWithInteger:section.end_t] forKey:@"end_t"];
    NSArray * list = [NSArray arrayWithContentsOfFile:self.plistPath];
    if (list == nil) {
        new_list = [[NSMutableArray alloc]init];
        [new_list addObject:[section_dict copy]];
    }else{
        for (NSDictionary* sec in list) {
            if ([[sec objectForKey:@"crn"] isEqualToString: section.crn]) {
                return NO;
            }
        }
        
        new_list = [NSMutableArray arrayWithArray:list];
        [new_list addObject:section_dict];
    }
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:new_list
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
     if(plistData) {
         [plistData writeToFile:self.plistPath atomically:YES];
     }
    return YES;
    //[new_list writeToFile:self.plistPath atomically:YES];
    
}

@end
