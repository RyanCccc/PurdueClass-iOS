//
//  PUCDetailViewController.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCDetailViewController.h"
#import "PUCDescriptionCell.h"
#import "PUCLinkedSectionViewController.h"

@interface NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end

@implementation NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end

@interface PUCDetailViewController ()

@property (strong, nonatomic)UIActionSheet* popup;

@end

@implementation PUCDetailViewController

- (IBAction)popUpActions:(id)sender {
    [self.popup showInView:[self.view window]]  ;
    NSLog(@"ME");
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Click index: %ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        BOOL success = [[PUCClassManager getManager]writeFollowing:self.section];
        if (success) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                            message:@"Added to follow list!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                            message:@"Failed to add to follow list!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
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
    self.title = self.section.crn;
    self.popup = [[UIActionSheet alloc] initWithTitle:@"Select options"
                                             delegate:self
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"Follow it", @"Check seats", nil];
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
    return 2 + [self.section.meetings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 2;
            break;
            
        case 1:
            rows = 5;
            if (self.section.linkedSections==nil) {
                rows--;
            }
            break;
        default:
            rows = 5;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    PUCDescriptionCell *descCell = nil;
    
    // Configure the cell...
    if (cell == nil){
        
        if (indexPath.section == 1 && indexPath.row == 4){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell =[[PUCDescriptionCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            descCell = (PUCDescriptionCell*)cell;
        }
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    descCell.titleLabel.text = @"Course Name:";
                    [descCell addText:self.section.course.name];
                    break;
                case 1:
                {
                    descCell.titleLabel.text = @"Description:";
                    [descCell addText:self.section.course.description];
                    break;
                }
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    descCell.titleLabel.text = @"CRN:";
                    [descCell addText:self.section.crn];
                    break;
                case 1:
                    descCell.titleLabel.text = @"Section Name:";
                    [descCell addText:self.section.name];
                    break;
                case 2:
                    descCell.titleLabel.text = @"Section Type:";
                    [descCell addText:self.section.type];
                    break;
                case 3:
                    descCell.titleLabel.text = @"Section Number:";
                    [descCell addText:self.section.number];
                    break;
                case 4:
                    cell.textLabel.text = @"Linked Sections";
                    //cell.detailTextLabel.text = @"Click to see";
                    break;
            }
            break;
        //Deal with meetings
        default:
            switch (indexPath.row) {
                case 0:
                    descCell.titleLabel.text = @"Day Of Week:";
                    [descCell addText:((PUCMeeting*)self.section.meetings[indexPath.section-2]).days];
                    break;
                case 1:
                    descCell.titleLabel.text = @"Instructor:";
                    [descCell addText:((PUCMeeting*)self.section.meetings[indexPath.section-2]).instructor];
                    break;
                case 2:
                    descCell.titleLabel.text = @"Location:";
                    [descCell addText:((PUCMeeting*)self.section.meetings[indexPath.section-2]).location];
                    break;
                case 3:
                    descCell.titleLabel.text = @"Time:";
                    [descCell addText:((PUCMeeting*)self.section.meetings[indexPath.section-2]).time];
                    break;
                case 4:
                    descCell.titleLabel.text = @"Date:";
                    [descCell addText:((PUCMeeting*)self.section.meetings[indexPath.section-2]).date];
                    break;
            }
            break;
    }
    
    return descCell==nil?cell:descCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title = nil;
    switch (section) {
        case 0:
            title = @"Course";
            break;
        case 1:
            title = @"Section";
            break;
        //Deal with meetings
        default:
            if ([self.section.meetings count]==1) {
                title = @"Schedule";
            }else{
                title = [NSString stringWithFormat:@"Schedule %d", section-1];
            }
            break;
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 4){
        return 44.0f;
    }else
    {
        PUCDescriptionCell * cell = (PUCDescriptionCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.getCorrectHeight;
    }
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
    // Get the new view controller using
    if ([[segue identifier] isEqualToString:@"sectionToLink"]){
        PUCLinkedSectionViewController * destinationVC = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        destinationVC.sections = self.section.linkedSections;
    }
}



- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 4)
    {
        [self performSegueWithIdentifier:@"sectionToLink" sender:self];
    }
    
}

@end
