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
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self->imagesArray[indexPath.row][@"url"]]];
        
                             UIImage* image = [[UIImage alloc] initWithData:imageData];
                             if (image) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     if (cell.tag == indexPath.row) {
                                         
                                         UIImageView *imageView = [cell.contentView viewWithTag:111];
                                         imageView.image = image;
                                     }
                                 });
                             }
                             });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}



@end
