//
//  PUCClassFactory.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-7.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCClassManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "PUCSectionCell.h"

static PUCClassManager* me;

@interface PUCClassManager ()

@property (nonatomic)BOOL isLoaded;

@end

@implementation PUCClassManager

+ (PUCClassManager *)getManager
{
    if (me==nil) {
        me = [[PUCClassManager alloc]init];
        me.subjects = [[NSMutableArray alloc]init];
        me.courses = [[NSMutableArray alloc]init];
        me.sections = [[NSMutableArray alloc]init];
        me.meetings = [[NSMutableArray alloc]init];
        
        me.term = @"Fall2014";
        me.isLoaded = NO;

        
    }
    return me;
}

- (NSArray*)getTermsByAction:(void(^)())handler
{
    if (self.terms==nil) {
        NSString *urlStr = @"http://purdue-class.chenrendong.com/course/json/terms/";
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.terms = responseObject;
            handler();
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else
        handler();
    return self.terms;
}

- (BOOL)isDataLoaded
{
    return self.isLoaded;
}

- (void)setToUnLoad
{
    self.isLoaded = NO;
}

- (void) getDataByAction:(void(^)())handler
{
    
    [self clearCourse];

    NSDictionary* catalogs = [me readCatalogsForTerm:self.term];
    if (catalogs==nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://purdue-class.chenrendong.com/course/json/catalogs/%@/", self.term];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.catalogs = (NSDictionary *)responseObject;
            [self writeCatalogs:responseObject forTerm:self.term];
            [self getCoursesFor:self.term action:handler];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else
    {
        self.catalogs = catalogs;
        [self getCoursesFor:self.term action:handler];
    }
    self.isLoaded = YES;
}

- (void) getCoursesFor:(NSString *)term action:(void(^)())handler
{
    NSArray * courses = [self readCoursesForTerm:term];
    if (courses==nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://purdue-class.chenrendong.com/course/json/all/%@/", term];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * data = (NSArray *)responseObject;
            self.subjects = [PUCSubject initWithMultiSubjects:data];
            [self writeCourses:responseObject forTerm:term];
            handler();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        self.subjects = [PUCSubject initWithMultiSubjects:courses];
        handler();
    }
}

-(void) getSeatsByCRN:(NSString* )crn forTerm:(NSString *)term action:(void(^)(id))handler
{
    NSString *urlStr = @"http://purdue-class.chenrendong.com/course/json/seats";
    NSDictionary* param = @{@"crn":crn, @"term":term};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@_followList.plist", self.term];
    NSString *followPath = [rootPath stringByAppendingPathComponent:fileName];
    NSMutableArray * new_list = nil;
    NSString *error;
    PUCSection * section = (PUCSection *)data;
    NSMutableDictionary* section_dict = [[NSMutableDictionary alloc]init];
    [section_dict setObject:section.number forKey:@"number"];
    [section_dict setObject:section.crn forKey:@"crn"];
    [section_dict setObject:section.time forKey:@"time"];
    NSString* courseName = [NSString stringWithFormat:@"%@%@", section.course.subject.subject, section.course.CNBR];
    [section_dict setObject:courseName forKey:@"name"];
    NSArray * list = [NSArray arrayWithContentsOfFile:followPath];
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
        [plistData writeToFile:followPath atomically:YES];
    }
    return YES;
    //[new_list writeToFile:self.plistPath atomically:YES];
}

- (NSArray *)readFollowing
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@_followList.plist", self.term];
    NSString *followPath = [rootPath stringByAppendingPathComponent:fileName];
    return [NSArray arrayWithContentsOfFile:followPath];
}

- (BOOL)deleteFollowing:(NSString*)crn
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@_followList.plist", self.term];
    NSString *followPath = [rootPath stringByAppendingPathComponent:fileName];
    NSString *error;
    NSMutableArray * list = [NSMutableArray arrayWithContentsOfFile:followPath];
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
        [plistData writeToFile:followPath atomically:YES];
    }
    return YES;
}

- (BOOL)clearCache
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString* path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@_catalogs.plist", term]];
//    NSError *error;
//    BOOL success = YES;
//    if ([fileManager fileExistsAtPath:path]) {
//        success = [fileManager removeItemAtPath:path error:&error];
//    }
//    path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.plist", term]];
//    if ([fileManager fileExistsAtPath:path]) {
//        success = [fileManager removeItemAtPath:path error:&error] && success;
//    }
//    return success;
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSInteger followListCount = 0;
    while ((files.count-followListCount) > 0) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if (error == nil) {
            for (NSString *path in directoryContents) {
                if ([path rangeOfString:@"followList"].location == NSNotFound) {
                    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
                    BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                    files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
                    if (!removeSuccess) {
                        // Error
                        return NO;
                    }
                }else{
                    followListCount++;
                }
            }
        } else {
            // Error
            return NO;
        }
    }
    return YES;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // NSLog(@"Seats button was pressed");
            [self showLoadingViewOn:cell.superview.superview withText:@"Checking seats for you!"];
            NSString *crn = ((PUCSectionCell*)cell).crn;
            [self getSeatsByCRN:crn forTerm:self.term action:^(id responseObj)
             {
                 [self stopAnimationOnView:(UITableView*)cell.superview.superview];
                 NSDictionary * result = responseObj;
                 NSNumber *max = [result objectForKey:@"max"];
                 NSNumber *remain = [result objectForKey:@"remain"];
                 NSNumber *taken = [result objectForKey:@"taken"];
                 NSString *msg = [NSString stringWithFormat:@"Capacity: %@\nRemaining: %@\nTaken: %@",max, remain, taken];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Seats"
                                                                 message:msg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             }];
            break;
        }
        case 1:
        {
            NSString *crn = ((PUCSectionCell*)cell).crn;
            PUCSection *section = [self getSectionByCRN:crn];
            BOOL success = [self writeFollowing:section];
            if (success) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                message:@"Added to follow list!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                message:@"Failed to add to follow list!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        }
        default:
            break;
    }
}

-(PUCLoadingView *)loadingView
{
    if (_loadingView==nil) {
        _loadingView = [[PUCLoadingView alloc] initWithFrame:CGRectMake(80, 150, 160, 120)];
    }
    return _loadingView;
}

- (void)showLoadingViewOn:(UITableView*)view withText:(NSString *)text
{
    [self.loadingView setFrame:CGRectMake(80, view.contentOffset.y+64.0f+150.0f, 160, 120)];
    view.scrollEnabled = NO;
    [self.loadingView addText:text];
    [view addSubview:self.loadingView];
    [self.loadingView startAnimation];
}

- (void)stopAnimationOnView:(UITableView*)view
{
    view.scrollEnabled = YES;
    [self.loadingView stopAnimation];
}

- (PUCSection *)getSectionByCRN:(NSString *)crn
{
    for (PUCSection* section in me.sections) {
        if ([section.crn isEqualToString:crn]) {
            return section;
        }
    }
    return nil;
}

@end
