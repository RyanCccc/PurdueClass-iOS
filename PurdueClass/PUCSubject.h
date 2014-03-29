//
//  PUCSubject.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-28.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUCSubject : NSObject

@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *subject_name;
@property (strong, nonatomic) NSArray *courses;

- (instancetype)initWith:(NSArray *) subject_raw;

+ (NSMutableArray *)initWithMultiSubjects:(NSArray *) subjects_raw;

@end
