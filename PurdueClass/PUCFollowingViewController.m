//
//  PUCFollowingViewController.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-10.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCFollowingViewController.h"
#import "PUCClassManager.h"
#import "PUCSectionCell.h"
#import "PUCDetailViewController.h"

@interface PUCFollowingViewController ()

@property (strong, nonatomic)UIActionSheet* popup;
@property (strong, nonatomic)PUCSection* selectedSection;
@end

@implementation PUCFollowingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)popUpActions:(id)sender {
    [self.popup showInView:[self.view window]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popup = [[UIActionSheet alloc] initWithTitle:@"Select options"
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"Clear cache", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //clean
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"Are you sure you want to clear cache?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Clear", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self clearCache];
    }
}

- (void)clearCache
{
    BOOL success = [[PUCClassManager getManager]clearCache];
    if (success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"Cleared cache!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"Failed to clear cache!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)refreshFollowList
{
    NSArray * list = [[PUCClassManager getManager] readFollowing];
    if (list!=nil) {
        self.followList = list;
    }else
    {
        self.followList = nil;
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshFollowList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.followList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PUCSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                   title:@"Seats"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.2f alpha:1.0f]
                                                    title:@"Delete"];
        cell = [[PUCSectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier
                                 containingTableView:self.tableView // For row height and selection
                                  leftUtilityButtons:nil
                                 rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }

    // NSArray * sections_for_cell = nil;
    //
    //if (tableView == self.searchDisplayController.searchResultsTableView) {
    //    sections_for_cell  = self.filteredSections;
    // } else {
    //sections_for_cell = [PUCClassManager getManager].sections;
    //}
    
    if (self.followList != nil)
    {
        NSDictionary* section =  self.followList[indexPath.row];
        cell.rightLabel.text = [section objectForKey:@"crn"];
        cell.leftLabel.text = [section objectForKey:@"name"];
        cell.downLeftLabel.text = [NSString stringWithFormat:@"Section No: %@", [section objectForKey:@"number"]];
        cell.downRightLabel.text = [section objectForKey:@"time"];
        cell.crn = [section objectForKey:@"crn"];
        //cell.downRightLabel.text = [section.linked_sections count]==0?@"No required sections":[NSString stringWithFormat:@"* %d required section", [section.linked_sections count]];
        
    }
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    PUCClassManager * mng = [PUCClassManager getManager];
    switch (index) {
        case 0:
        {
            NSLog(@"Seats button was pressed");
            PUCClassManager *mng = [PUCClassManager getManager];
            [mng showLoadingViewOn:self.tableView withText:@"Checking seats for you!"];
            NSString *crn = ((PUCSectionCell*)cell).crn;
            [mng getSeatsByCRN:crn forTerm:mng.term action:^(id responseObj)
             {
                 [mng stopAnimationOnView:self.tableView];
                 NSDictionary * result = responseObj;
                 NSNumber *max = [result objectForKey:@"max"];
                 NSNumber *remain = [result objectForKey:@"remain"];
                 NSNumber *taken = [result objectForKey:@"taken"];
                 NSString *msg = [NSString stringWithFormat:@"Capacity: %@\nRemaining: %@\nTaken: %@",max, remain, taken];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Seats"
                                                                 message:msg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             }];
            break;
        }
        case 1:
        {
            BOOL success = [mng deleteFollowing: ((PUCSectionCell*) cell).rightLabel.text];
            if (success){
                [self refreshFollowList];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                message:@"Delete Successfully!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                message:@"Delete failed!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }

            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* sectionDict =  self.followList[indexPath.row];
    NSString *crn = [sectionDict objectForKey:@"crn"];
    PUCSection * section = [[PUCClassManager getManager]getSectionByCRN:crn];
    self.selectedSection = section;
    [self performSegueWithIdentifier:@"sectionToDetail" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sectionToDetail"]) {
        PUCDetailViewController *destinationVc = [segue destinationViewController];
        destinationVc.section = self.selectedSection;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [PUCClassManager getManager].term;
}

@end
