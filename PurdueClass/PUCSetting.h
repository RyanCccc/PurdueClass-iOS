//
//  PUCSetting.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-4-14.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUCSetting : NSObject

@property (nonatomic) BOOL subjectHintShown;
@property (nonatomic) BOOL sectionHintShown;
@property (nonatomic) BOOL linkedHintShown;

+ (PUCSetting*)readSetting;
- (BOOL)writeSetting;

@end