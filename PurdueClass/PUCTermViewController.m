//
//  PUCTermViewController.m
//  PurdueClass
//
//  Created by Rendong Chen on 14-4-10.
//  Copyright (c) 2014年 Rendong Chen. All rights reserved.
//

#import "PUCTermViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "PUCClassManager.h"

@interface PUCTermViewController ()

@property (nonatomic, strong)NSArray* terms;

@end

@implementation PUCTermViewController

- (IBAction)cancelModalView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.terms = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.terms count]==0) {
        [[PUCClassManager getManager]showLoadingViewOn:self.tableView withText:@"Getting available terms."];
        [[PUCClassManager getManager] getTermsByAction:^(){
            [[PUCClassManager getManager] stopAnimationOnView:self.tableView];
            self.terms = [PUCClassManager getManager].terms;
            [self.tableView reloadData];
        }failed:^(){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                            message:@"Failed to load the data!\n(Check your networking and try again)"
                                                           delegate:self
                                                  cancelButtonTitle:@"Retry"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[PUCClassManager getManager] getTermsByAction:^(){
            [[PUCClassManager getManager] stopAnimationOnView:self.tableView];
            self.terms = [PUCClassManager getManager].terms;
            [self.tableView reloadData];
        }failed:^(){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                            message:@"Failed to load the data!\n(Check your networking and try again)"
                                                           delegate:self
                                                  cancelButtonTitle:@"Retry"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.terms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.terms objectAtIndex:indexPath.row];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PUCClassManager *mng = [PUCClassManager getManager];
    if(![mng.term isEqualToString:[self.terms objectAtIndex:indexPath.row]]){
        mng.term = [self.terms objectAtIndex:indexPath.row];
        [mng setToUnLoad];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
