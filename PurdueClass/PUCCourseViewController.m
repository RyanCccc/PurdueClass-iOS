//
//  PUCCourseViewController.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-3-8.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCCourseViewController.h"
#import "PUCSectionViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface PUCCourseViewController ()

// Get by subject
@property (strong, nonatomic) NSArray * CNBRs;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString * selectedCNBR;

@end

@implementation PUCCourseViewController


- (void)connect
{
    NSString *urlStr = [NSString stringWithFormat:@"http://purdue-class.chenrendong.com/course/subject/%@/", self.subject];
    //NSURL *url = [[NSURL alloc]initWithString:urlStr];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.CNBRs = (NSArray *)responseObject;
        [self.tableView reloadData];
        [(UIActivityIndicatorView*)[self.view viewWithTag:12] stopAnimating];
        if ([self.CNBRs count]==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No course"
                                                            message:[NSString stringWithFormat:@"Subject %@ doesn't have course", self.subject]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedFailureReason
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
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
    /*
    if (self.needToRefresh) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(160, 200);
        spinner.tag = 12;
        [self.view addSubview:spinner];
        [spinner startAnimating];
    }
     */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.subject.subject;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        //[self connect];
    NSMutableArray* courses_crns = [[NSMutableArray alloc]init];
    for (PUCCourse* course in self.subject.courses) {
        [courses_crns addObject:course.CNBR];
    }
    self.CNBRs = [NSArray arrayWithArray:courses_crns];
    self.CNBRs = [self.CNBRs sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.CNBRs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = (NSString *)[self.CNBRs objectAtIndex:indexPath.row];
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"courseToSection"]) {
        PUCSectionViewController *destinationVc = [segue destinationViewController];
        for (PUCSubject* subject in [PUCClassManager getManager].subjects) {
            if ([subject.subject isEqualToString:self.subject.subject]) {
                for (PUCCourse* course in subject.courses) {
                    if ([course.CNBR isEqualToString:self.selectedCNBR]) {
                        destinationVc.course = course;
                        break;
                    }
                }
                break;
            }
        }
    }
    
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCNBR = (NSString *)[self.CNBRs objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"courseToSection" sender:self];
}

@end
