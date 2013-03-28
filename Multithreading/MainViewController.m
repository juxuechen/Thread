//
//  MainViewController.m
//  Multithreading
//
//  Created by Juxue Chen on 13-3-28.
//
//

#import "MainViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"m";
    }
    return self;
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15.];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"B等待A结束,dispatch,semaphore";
            break;
        case 1:
            cell.textLabel.text = @"NSOperationQueue,NSInvocationOperation";
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id viewController = nil;
    switch (indexPath.row) {
        case 0:
            viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
            break;
        case 1:
            viewController = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
