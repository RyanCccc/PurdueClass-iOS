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
#import "PUCLoadingView.h"
#import <SWTableViewCell.h>

@interface PUCClassManager : NSObject<SWTableViewCellDelegate>

@property (strong, nonatomic)NSDictionary* catalogs;
@property (strong, nonatomic)NSMutableArray * sections;
@property (strong, nonatomic)NSMutableArray * meetings;
@property (strong, nonatomic)NSMutableArray * courses;
@property (strong, nonatomic)NSMutableArray * subjects;
@property (strong, nonatomic)NSString *term;
@property (strong, nonatomic)NSArray *terms;
@property (strong, nonatomic)PUCLoadingView *loadingView;


+ (PUCClassManager *)getManager;
- (void) getDataByAction:(void(^)())handler;
- (void) clearCourse;
- (BOOL)writeFollowing:(id)data;
- (NSArray *)readFollowing;
- (BOOL)deleteFollowing:(NSString*)crn;
- (BOOL)writeCourses:(NSString* )data forTerm:(NSString *)term;
- (NSInteger) getRequiredSectionsBy:(PUCSection*) section;
-(void) getSeatsByCRN:(NSString* )crn forTerm:(NSString *)term action:(void(^)(id))handler;
- (void)stopAnimationOnView:(UITableView*)view;
- (void)showLoadingViewOn:(UIView*)view withText:(NSString *)text;
- (PUCSection *)getSectionByCRN:(NSString *)crn;
- (BOOL)isDataLoaded;
- (void)setToUnLoad;
- (BOOL)clearCache;
- (NSArray*)getTermsByAction:(void(^)())handler;

@end
