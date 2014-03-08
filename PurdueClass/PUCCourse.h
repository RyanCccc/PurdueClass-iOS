//
//  PUCCourse.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCTerm.h"

@interface PUCCourse : NSObject

@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *subject_name;
@property (strong, nonatomic) NSString *CNBR;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) PUCTerm *term;
@property (strong, nonatomic) NSArray* schedules;

- (instancetype)initWithSubject:(NSString*)subject CNBR:(NSString*)CNBR;
+ (NSArray *)getSubjects;

@end
