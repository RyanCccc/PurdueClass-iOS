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
    
    [self clearCourse];

    NSDictionary* catalogs = [me readCatalogsForTerm:term];
    if (catalogs==nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://purdue-class.chenrendong.com/course/json/catalogs/%@/", term];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            NSLog(@"test");
            //self.catalogs = (NSDictionary *)responseObject;
            [self writeCatalogs:responseObject forTerm:term];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else
    {
        self.catalogs = catalogs;
    }

    NSArray * courses = [self readCoursesForTerm:term];
    if (courses==nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://purdue-class.chenrendong.com/course/json/all/%@/", term];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * data = (NSArray *)responseObject;
            self.subjects = [PUCSubject initWithMultiSubjects:data];
            [self writeCourses:responseObject forTerm:term];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        self.subjects = [PUCSubject initWithMultiSubjects:courses];
    }
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

- (BOOL)writeCatalogs:(NSString* )data forTerm:(NSString *)term
{
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@_catalogs.plist", term]];
    NSMutableDictionary* catalogsData =[[NSMutableDictionary alloc]init];
    [catalogsData setObject:data forKey:@"data"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:catalogsData
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:path atomically:YES];
    }
    return YES;
}

- (NSArray*)readCoursesForTerm:(NSString *)term
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.plist", term]];
    NSDictionary * courses = [NSDictionary dictionaryWithContentsOfFile:path];
    if (courses==nil) {
        return nil;
    }
    return (NSArray*)[courses objectForKey:@"data"];
}

- (NSDictionary*)readCatalogsForTerm:(NSString *)term
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@_catalogs.plist", term]];
    NSDictionary * catalogs = [NSDictionary dictionaryWithContentsOfFile:path];
    if (catalogs==nil) {
        return nil;
    }
    return (NSDictionary*)[catalogs objectForKey:@"data"];
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

- (BOOL)deleteFollowing:(NSString*)crn
{
    NSString *error;
    NSMutableArray * list = [NSMutableArray arrayWithContentsOfFile:self.followPath];
    if (list == nil) {
        return NO;
    }else{
        NSDictionary* removeObj = nil;
        for (NSDictionary* sec in list) {
            if ([[sec objectForKey:@"crn"] isEqualToString: crn]) {
                removeObj = sec;
            }
        }
        [list removeObject:removeObj];
    }
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:list
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:self.followPath atomically:YES];
    }
    return YES;
}

@end
