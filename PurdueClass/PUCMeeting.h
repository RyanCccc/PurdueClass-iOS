//
//  PUCMeeting.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCSection.h"

@interface PUCMeeting : NSObject

@property (strong, nonatomic) NSString* days;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* instructor;
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) NSString* time;
@property (strong, nonatomic) NSString* type;

@property (strong, nonatomic) PUCSection* section;

+ (NSArray *)initWithMultiMeetings:(NSArray *)meetings_raw by:(PUCSection *)section;

@end