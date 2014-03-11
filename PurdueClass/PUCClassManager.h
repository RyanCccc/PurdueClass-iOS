//
//  PUCClassFactory.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-7.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCCourse.h"
#import "PUCSchedule.h"
#import "PUCSection.h"
#import "PUCMeeting.h"

@interface PUCClassManager : NSObject

@property (strong, nonatomic)NSMutableArray *schedules;
@property (strong, nonatomic)NSMutableArray *sections;
@property (strong, nonatomic)NSMutableArray *meetings;
@property (strong, nonatomic)PUCCourse* course;
@property (strong, nonatomic)NSString *plistPath;

+ (PUCClassManager *)getManager;
- (void) getCourse:(id) JSON;
- (void) clearCourse;
- (void)writeData:(id)data;

@end
