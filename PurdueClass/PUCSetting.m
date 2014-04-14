//
//  PUCSetting.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-4-14.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCSetting.h"

@implementation PUCSetting


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.subjectHintShown = NO;
        self.sectionHintShown = NO;
        self.linkedHintShown = NO;
    }
    return self;
}

- (BOOL)writeSetting
{
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [rootPath stringByAppendingPathComponent:@"setting.plist"];
    NSDictionary *dict = @{@"subjectHintShown": [NSNumber numberWithBool:self.subjectHintShown],
                           @"sectionHintShown": [NSNumber numberWithBool:self.sectionHintShown],
                           @"linkedHintShown": [NSNumber numberWithBool:self.linkedHintShown],};
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:path atomically:YES];
        return YES;
    }else
    {
        return NO;
    }
}

+ (PUCSetting*)readSetting
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [rootPath stringByAppendingPathComponent:@"setting.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    PUCSetting * setting = [[PUCSetting alloc]init];
    if (dict) {
        setting.subjectHintShown = [[dict objectForKey:@"subjectHintShown"]boolValue];
        setting.sectionHintShown = [[dict objectForKey:@"sectionHintShown"]boolValue];
        setting.linkedHintShown = [[dict objectForKey:@"linkedHintShown"]boolValue];
    }
    return setting;
}

@end
