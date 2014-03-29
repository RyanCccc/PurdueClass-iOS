//
//  PUCLinkedSectionViewController.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-10.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCLinkedSectionViewController.h"
#import "PUCSectionCell.h"
#import "PUCSection.h"

@interface PUCLinkedSectionViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic)NSArray* filteredSections;

@end

@implementation PUCLinkedSectionViewController


- (void)changeSeg: (id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    self.filteredSections = [self.sections objectAtIndex:[segmentedControl selectedSegmentIndex]];
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
    [self.segmentedControl removeAllSegments];
    for (int i=0; i<[self.sections count]; i++) {
        [self.segmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"Required part %d", i+1]
                                              atIndex:i
                                             animated:NO];
    }
    self.segmentedControl.selectedSegmentIndex = 0;
    self.filteredSections = self.sections[0];
    [self.segmentedControl addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
        cell.leftLabel.text = section.time;
        cell.downLeftLabel.text = [NSString stringWithFormat:@"Section No: %@", section.number];
        //cell.downRightLabel.text = [section.linked_sections count]==0?@"No required sections":[NSString stringWithFormat:@"* %d required section", [section.linked_sections count]];
    }
    return cell;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
