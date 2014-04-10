//
//  PUCCourseViewController.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-6.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCSubjectViewController.h"
#import "PUCCourseViewController.h"
#import "PUCClassManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "PUCLoadingView.h"

@interface PUCSubjectViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchTermBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *courseTable;
@property (strong, nonatomic) NSArray* subjects;
@property (strong, nonatomic) NSMutableArray* filteredSubjects;
@property (strong, nonatomic) NSArray* titles;
@property (strong, nonatomic) NSString* selectedSubject;
@end

@implementation PUCSubjectViewController

- (IBAction)showModalView:(id)sender {
    [self performSegueWithIdentifier:@"subjectToTerm" sender:self];
}

- (NSArray *)titles
{
    if (_titles == nil) {
        NSMutableArray * titles_tmp = [[NSMutableArray alloc]init];
        for (NSArray* sections in self.subjects)
        {
            [titles_tmp addObject:[[[sections objectAtIndex:0]objectAtIndex:0]substringWithRange:NSMakeRange(0, 1)]];
        }
        return [NSArray arrayWithArray:titles_tmp];
    }
    return _titles;
}

- (void)refreshTitles
{
    NSMutableArray * titles_tmp = [[NSMutableArray alloc]init];
    for (NSArray* sections in self.filteredSubjects)
    {
        [titles_tmp addObject:[[[sections objectAtIndex:0]objectAtIndex:0]substringWithRange:NSMakeRange(0, 1)]];
    }
    self.titles = [NSArray arrayWithArray:titles_tmp];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![[PUCClassManager getManager] isDataLoaded]) {
        [[PUCClassManager getManager]showLoadingViewOn:self.tableView withText:@"It may take a while for the first time. Please be patient."];
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
        [self.switchTermBtn setEnabled:NO];
        [self.searchBar setHidden:YES];
        [[PUCClassManager getManager]getDataByAction:^()
         {
             [[PUCClassManager getManager] stopAnimationOnView:self.tableView];
             [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
             [self.switchTermBtn setEnabled:YES];
             [self.searchBar setHidden:NO];
             // TODO
             NSArray* subjects_tmp = [self convertSubjectList:[[PUCClassManager getManager]subjects]];
             self.subjects = subjects_tmp;
             self.filteredSubjects = [[NSMutableArray alloc]initWithArray:self.subjects];
             [[self courseTable]reloadData];
         }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[PUCClassManager getManager] isDataLoaded]) {
        [self.filteredSubjects removeAllObjects];
        [self.courseTable reloadData];
        [self.navigationItem setTitle:[NSString stringWithFormat: @"%@",[PUCClassManager getManager].term]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[PUCClassManager getManager]showLoadingViewOn:self.tableView withText:@"It may take a while for the first time. Please be patient."];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray* )convertSubjectList: (NSArray *)subjects
{
    if ([subjects count]==0) {
        return [[NSMutableArray alloc]init];
    }
    NSArray * subjects_old = subjects;
    NSMutableArray* subjects_raw = [[NSMutableArray alloc]init];
    for (PUCSubject* subject in subjects_old) {
        NSArray* subject_array = @[subject.subject, subject.subject_name];
        [subjects_raw addObject:subject_array];
    }
    
    NSMutableArray * subjects_tmp = [[NSMutableArray alloc]init];
    NSMutableArray * current_list = [[NSMutableArray alloc]init];
    unichar first_c = [subjects_raw[0][0] characterAtIndex:0];
    for (NSArray * sub_detail in subjects_raw) {
        NSString *sub = (NSString *)sub_detail[0];
        if (first_c == [sub characterAtIndex:0]){
            [current_list addObject:[sub_detail copy]];
        }else{
            first_c = [sub characterAtIndex:0];
            [subjects_tmp addObject:[current_list copy]];
            [current_list removeAllObjects];
            [current_list addObject:[sub_detail copy]];
        }
    }
    [subjects_tmp addObject:[current_list copy]];
    return subjects_tmp;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.filteredSubjects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[self.filteredSubjects objectAtIndex:section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSArray * subject = [[self.filteredSubjects objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *)[subject objectAtIndex:0];
    cell.detailTextLabel.text = (NSString *)[subject objectAtIndex:1];

    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.titles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    for (NSArray* sections in self.subjects)
    {
        if ([title isEqualToString:[[[sections objectAtIndex:0]objectAtIndex:0]substringWithRange:NSMakeRange(0, 1)]])
        {
            return [self.subjects indexOfObject:sections];
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.titles objectAtIndex:section];
}


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredSubjects removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        self.filteredSubjects = [[NSMutableArray alloc]initWithArray:self.subjects];
    }else{
        // Filter the array using NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.subject contains[c] %@",searchText];
        NSMutableArray* filteredRawSubjects = [NSMutableArray arrayWithArray:[[PUCClassManager getManager].subjects filteredArrayUsingPredicate:predicate]];
        self.filteredSubjects = (NSMutableArray *)[self convertSubjectList:filteredRawSubjects];
    }
    [self refreshTitles];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   if ([[segue identifier] isEqualToString:@"subjectToCourse"]) {
       PUCCourseViewController *destinationVc = [segue destinationViewController];
       for (PUCSubject* subject in [PUCClassManager getManager].subjects) {
           if ([subject.subject isEqualToString:self.selectedSubject]) {
               destinationVc.subject = subject;
               break;
           }
       }
   }
    
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * subject = [[self.filteredSubjects objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    self.selectedSubject = (NSString *)[subject objectAtIndex:0];    [self performSegueWithIdentifier:@"subjectToCourse" sender:self];
}

@end
