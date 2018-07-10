//
//  DetailsPostViewController.m
//  NYTimes
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "DetailsPostViewController.h"

@interface DetailsPostViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *imagesArray;
}

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DetailsPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.mediaDictionary[@"caption"] == nil || self.mediaDictionary[@"caption"] == [NSNull null]) {
        self.captionLabel.hidden = YES;
    } else {
        self.captionLabel.hidden = NO;
        self.captionLabel.text =  self.mediaDictionary[@"caption"];
    }
    
    imagesArray = (NSArray *)self.mediaDictionary[@"media-metadata"];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView reloadData];
}

#pragma mark - TableView DataScource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return imagesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photocell"];
    
    cell.tag = indexPath.row;
    
    UIImageView *imageView = [cell.contentView viewWithTag:111];
    
    imageView.image = [UIImage imageNamed:@"image.png"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        NSString *imageURLString = self->imagesArray[indexPath.row][@"url"];
       
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    imageView.image = image;
                });
            }
        
    });
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}



@end
