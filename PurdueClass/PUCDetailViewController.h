//
//  PUCDetailViewController.h
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUCClassManager.h"

@interface PUCDetailViewController : UITableViewController<UIActionSheetDelegate>

@property (strong, nonatomic)PUCSection * section;

@end