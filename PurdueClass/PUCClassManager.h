//
//  PUCClassFactory.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-7.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCSection.h"
#import "PUCSubject.h"
#import "PUCMeeting.h"
#import "PUCCourse.h"

@interface PUCClassManager : NSObject

@property (strong, nonatomic)NSMutableArray * sections;
@property (strong, nonatomic)NSMutableArray * meetings;
@property (strong, nonatomic)NSMutableArray * courses;
@property (strong, nonatomic)NSMutableArray * subjects;
@property (strong, nonatomic)NSString *followPath;

+ (PUCClassManager *)getManager;
- (void) getDataFor:(NSString *)term;
- (void) clearCourse;
- (BOOL)writeFollowing:(id)data;
- (BOOL)writeCourses:(NSString* )data forTerm:(NSString *)term;
- (NSArray*)readCoursesforTerm:(NSString *)term;
- (NSInteger) getRequiredSectionsBy:(PUCSection*) section;
@end
