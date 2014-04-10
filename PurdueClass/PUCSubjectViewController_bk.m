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

@interface PUCSubjectViewController ()

@property (strong, nonatomic) IBOutlet UITableView *courseTable;
@property (strong, nonatomic) NSArray* subjects;
@property (strong, nonatomic) NSArray* titles;
@property (strong, nonatomic) NSString* selectedSubject;
@end

@implementation PUCSubjectViewController

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
    [[PUCClassManager getManager]getDataFor:@"Fall2014"];
    // TODO
    NSArray * subjects_old = [[PUCClassManager getManager]subjects];
    NSMutableArray* subjects_raw = [[NSMutableArray alloc]init];
    for (PUCSubject* subject in subjects_old) {
        NSArray* subject_array = @[subject.subject, subject.subject_name];
        [subjects_raw addObject:subject_array];
    }
    
    NSMutableArray * subjects_tmp = [[NSMutableArray alloc]init];
    unichar first_c = 'A';
    NSMutableArray * current_list = [[NSMutableArray alloc]init];
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
    self.subjects = [NSArray arrayWithArray:subjects_tmp];
    [[self courseTable]reloadData];
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.subjects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[self.subjects objectAtIndex:section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSArray * subject = [[self.subjects objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
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
    NSArray * subject = [[self.subjects objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    self.selectedSubject = (NSString *)[subject objectAtIndex:0];
    [self performSegueWithIdentifier:@"subjectToCourse" sender:self];
}

@end
