//
//  PUCSectionViewController.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUCClassManager.h"
#import "EMHint.h"

@interface PUCSectionViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, EMHintDelegate>

//Get from course view
@property (strong, nonatomic)PUCCourse * course;

@end
