//
//  PUCSectionViewController.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCSectionViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "PUCClassManager.h"
#import "PUCSectionCell.h"
#import "PUCDetailViewController.h"

@interface PUCSectionViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic)NSArray * filteredSections;
@property (strong, nonatomic)PUCSection * selectedSection;

@end

@implementation PUCSectionViewController

- (void)connect
{
    NSString *urlStr = [NSString stringWithFormat:@"http://purdue-class.chenrendong.com/course/subject/%@/%@/", self.subject, self.CNBR];
    //NSURL *url = [[NSURL alloc]initWithString:urlStr];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [[PUCClassManager getManager]getCourse:responseObject];
        [self refresh];
        [(UIActivityIndicatorView*)[self.view viewWithTag:12] stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)refresh
{
    self.filteredSections = [PUCClassManager getManager].sections;
    [self.tableView reloadData];
    
    NSMutableArray* types = [[NSMutableArray alloc]init];
    for (PUCSchedule * schedule in [PUCClassManager getManager].schedules)
    {
        [types addObject: schedule.type_id];
    }
    for (int i=0; i<[types count]; i++)
        [self.segmentedControl insertSegmentWithTitle:[types objectAtIndex:i] atIndex:i+1 animated:NO];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    /*
    NSMutableArray* titles = [[NSMutableArray alloc]init];
    for (PUCSchedule * schedule in [PUCClassManager getManager].schedules)
    {
        [titles addObject: schedule.type_name];
    }
    self.searchDisplayController.searchBar.scopeButtonTitles = titles;
    [self.tableView setNeedsDisplay];
    [self.searchBar setNeedsDisplay];
    [self.searchBar needsUpdateConstraints];
    */
}

- (void)changeSeg:(id) sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString * segTitle = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    PUCSchedule * selectedSchedule = nil;
    if ([segTitle isEqualToString:@"All"]) {
        self.filteredSections = [PUCClassManager getManager].sections;
    }else{
        for (PUCSchedule * schedule in [PUCClassManager getManager].schedules)
        {
            if ([schedule.type_id isEqualToString:segTitle])
            {
                selectedSchedule = schedule;
            }
        }
        self.filteredSections = selectedSchedule.sections;
    }
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PUCClassManager getManager]clearCourse];
    [self.segmentedControl removeAllSegments];
    [self.segmentedControl insertSegmentWithTitle:@"All" atIndex:0 animated:NO];
    
    self.title = [NSString stringWithFormat:@"%@%@", self.subject, self.CNBR];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 200);
    spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [self connect];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredSections removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.crn contains[c] %@",searchText];
    self.filteredSections = [NSMutableArray arrayWithArray:[[PUCClassManager getManager].sections filteredArrayUsingPredicate:predicate]];
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
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.filteredSections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PUCSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [leftUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                    title:@"Seats"];
        [leftUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.5f blue:0.35f alpha:1.0]
                                                   title:@"Requires"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"More"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.188f green:0.231f blue:1.0f alpha:1.0f]
                                                    title:@"Follow"];
        cell = [[PUCSectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier
                                 containingTableView:self.tableView // For row height and selection
                                  leftUtilityButtons:leftUtilityButtons
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
    
    if (self.filteredSections != nil)
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"start_t" ascending:YES];
        NSArray *sortedSections =[self.filteredSections sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        PUCSection * section = (PUCSection *)[sortedSections objectAtIndex:indexPath.row];
        cell.rightLabel.text = [NSString stringWithFormat:@"CRN: %@", section.crn];
        cell.leftLabel.text = [NSString stringWithFormat:@"%d:%d ~ %d:%d", section.start_t/60, section.start_t%60, section.end_t/60, section.end_t%60];
        cell.downLeftLabel.text = [NSString stringWithFormat:@"Section No: %@", section.number];
        cell.downRightLabel.text = [section.linked_sections count]==0?@"No required sections":[NSString stringWithFormat:@"* %d required section", [section.linked_sections count]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"start_t" ascending:YES];
    NSArray *sortedSections =[self.filteredSections sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    PUCSection * section = (PUCSection *)[sortedSections objectAtIndex:indexPath.row];
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


@end
