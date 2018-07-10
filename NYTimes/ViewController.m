//
//  ViewController.m
//  NYTimes
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "DetailsPostViewController.h"
#import "ServiceManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *dataArray;
    
    AppDelegate *appDelegate;
    
    ServiceManager *serviceManager;
    
    DetailsPostViewController *detailsPostViewController;
}

@property (weak, nonatomic) IBOutlet UITableView *postsTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self getremoteData];
}

- (void)getremoteData {
    
    [[ServiceManager sharedInstance] getDataFromServerwithCompletionBlock:^(id response, NSError *error) {
        
        if ([response isKindOfClass:[NSArray class]]) {

            self->dataArray = (NSArray *)response;
            
            [self.postsTableView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView DataScource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postIdentifier"];
    
    NSDictionary *post = dataArray[indexPath.row];
    
    UILabel *titleLabel = [cell.contentView viewWithTag:111];
    UILabel *authorLabel = [cell.contentView viewWithTag:222];
    UILabel *dateLabel = [cell.contentView viewWithTag:333];
    UILabel *detailLabel = [cell.contentView viewWithTag:444];
    
    titleLabel.text = post[@"title"];
    authorLabel.text = post[@"byline"];
    dateLabel.text = post[@"published_date"];
    detailLabel.text = post[@"abstract"];
    
    return cell;
}


#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!detailsPostViewController)
        detailsPostViewController = [appDelegate.storyBoard instantiateViewControllerWithIdentifier:@"DetailsPostViewController"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([(NSArray *)[dataArray[indexPath.row] valueForKey:@"media"] count] > 0) {
        
        detailsPostViewController.mediaDictionary = [dataArray[indexPath.row] valueForKey:@"media"][0];
        
        [self.navigationController pushViewController:detailsPostViewController animated:YES];
    }
    
    
}

@end
