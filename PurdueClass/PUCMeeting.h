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

@property (strong, nonatomic) NSString* DayOfWeek;
@property (strong, nonatomic) NSString* instructor;
@property (strong, nonatomic) NSString* building;
@property (strong, nonatomic) NSString* room;
@property (nonatomic) NSInteger start_t;
@property (nonatomic) NSInteger end_t;
@property (strong, nonatomic) PUCSection* section;

- (instancetype)initWithJSON:(id) JSON;
+ (NSArray *)initWithMultiMeetings:(id) JSON;

@end