//
//  PUCDetailViewController.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCDetailViewController.h"
#import "PUCDescriptionCell.h"

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
    [self.popup showInView:self.view];
    NSLog(@"ME");
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
    self.title = self.section.schedule.course.code;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 3;
            break;
            
        case 1:
            rows = 4;
            if ([self.section.linked_sections count]==0) {
                rows--;
            }
            break;
            
        case 2:
            rows = 5;
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    // Configure the cell...
    if (cell == nil){
        if (indexPath.section == 0 && indexPath.row == 2) {
            cell =[[PUCDescriptionCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }else if (indexPath.section == 1 && indexPath.row == 3)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = self.section.schedule.course.title;
                    break;
                case 1:
                    cell.textLabel.text = @"Credit:";
                    cell.detailTextLabel.text = self.section.schedule.course.credit;
                    break;
                case 2:
                {
                    NSString *desc = [NSString stringWithFormat:@"Description: %@", self.section.schedule.course.description];
                    [((PUCDescriptionCell *)cell) addText:desc];
                    break;
                }
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"CRN:";
                    cell.detailTextLabel.text = self.section.crn;
                    break;
                case 1:
                    cell.textLabel.text = @"Section Type:";
                    cell.detailTextLabel.text = self.section.schedule.type_name;
                    break;
                case 2:
                    cell.textLabel.text = @"Section Number:";
                    cell.detailTextLabel.text = self.section.number;
                    break;
                case 3:
                    cell.textLabel.text = @"Linked Sections";
                    //cell.detailTextLabel.text = @"Click to see";
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text = @"Day Of Week:";
                    NSMutableString * days = [[NSMutableString alloc]init];
                    for (PUCMeeting * meeting in self.section.meetings)
                    {
                        if (![days containsString:[meeting.DayOfWeek substringToIndex:3]])
                            [days appendFormat:@"%@,",[meeting.DayOfWeek substringToIndex:3]];
                    }
                    cell.detailTextLabel.text = [days substringToIndex:[days length]-1];
                    break;}
                case 1:
                    cell.textLabel.text = @"Instructor:";
                    cell.detailTextLabel.text = ((PUCMeeting*)self.section.meetings[0]).instructor;
                    break;
                case 2:
                    cell.textLabel.text = @"Building:";
                    cell.detailTextLabel.text = ((PUCMeeting*)self.section.meetings[0]).building;
                    break;
                case 3:
                    cell.textLabel.text = @"Room:";
                    cell.detailTextLabel.text = ((PUCMeeting*)self.section.meetings[0]).room;
                    break;
                case 4:
                    cell.textLabel.text = @"Time:";
                    NSInteger start_t = ((PUCMeeting*)self.section.meetings[0]).start_t;
                    NSInteger end_t = ((PUCMeeting*)self.section.meetings[0]).end_t;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:%d ~ %d:%d", start_t/60, start_t%60, end_t/60, end_t%60];
                    break;
            }
            break;
    }
    
    return cell;
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
            
        case 2:
            title = @"Schedule";
            break;
        default:
            break;
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2){
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 6), 20000.0f);
        CGSize size = [[NSString stringWithFormat:@"Description: %@", self.section.schedule.course.description] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        return  MAX(size.height, 44.0f);
    }else
    {
        return 44.0f;
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
