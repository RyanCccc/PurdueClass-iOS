//
//  PUCClassFactory.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-7.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCClassManager.h"
#import "AFHTTPRequestOperationManager.h"

static PUCClassManager* me;

@implementation PUCClassManager

+ (PUCClassManager *)getManager
{
    if (me==nil) {
        me = [[PUCClassManager alloc]init];
        me.subjects = [[NSMutableArray alloc]init];
        me.courses = [[NSMutableArray alloc]init];
        me.sections = [[NSMutableArray alloc]init];
        me.meetings = [[NSMutableArray alloc]init];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        me.followPath = [rootPath stringByAppendingPathComponent:@"followList.plist"];
        
    }
    return me;
}

- (void) getDataFor:(NSString *)term
{
    [me.subjects removeAllObjects];
    [me.courses removeAllObjects];
    [me.sections removeAllObjects];
    [me.meetings removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"http://purdue-class.chenrendong.com/course/json/all/%@/", term];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * data = (NSArray *)responseObject;
        me.subjects = [PUCSubject initWithMultiSubjects:data];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void) clearCourse
{
    [me.subjects removeAllObjects];
    [me.courses removeAllObjects];
    [me.sections removeAllObjects];
    [me.meetings removeAllObjects];
}

- (NSInteger) getRequiredSectionsBy:(PUCSection*) section
{
    /*
    NSMutableArray* requiredSections = [[NSMutableArray alloc]init];
    if (section.required_linked_id==nil) {
        return nil;
    }
    PUCCourse* course = section.course;
    for (PUCSection* sec in course.sections) {
        if (![sec isEqual:section] && [sec.linked_id isEqualToString:section.required_linked_id]) {
            <#statements#>
        }
    }
    */
    return 1;
}

- (BOOL)writeCourses:(NSString* )data forTerm:(NSString *)term
{
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.plist", term]];
    NSMutableDictionary* courseData =[[NSMutableDictionary alloc]init];
    [courseData setObject:data forKey:@"data"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:courseData
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:path atomically:YES];
    }
    return YES;
}

- (NSArray*)readCoursesforTerm:(NSString *)term
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.plist", term]];
    NSDictionary * courses = [NSDictionary dictionaryWithContentsOfFile:path];
    if (courses==nil) {
        return nil;
    }
    return (NSArray*)[courses objectForKey:@"data"];
}

- (BOOL)writeFollowing:(id)data
{
    NSMutableArray * new_list = nil;
    NSString *error;
    PUCSection * section = (PUCSection *)data;
    NSMutableDictionary* section_dict = [[NSMutableDictionary alloc]init];
    [section_dict setObject:section.number forKey:@"number"];
    [section_dict setObject:section.crn forKey:@"crn"];
    [section_dict setObject:section.time forKey:@"time"];
    NSArray * list = [NSArray arrayWithContentsOfFile:self.followPath];
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
         [plistData writeToFile:self.followPath atomically:YES];
     }
    return YES;
    //[new_list writeToFile:self.plistPath atomically:YES];
    
}

@end
