//
//  DetailsPostViewController.m
//  NYTimes
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "DetailsPostViewController.h"

@interface DetailsPostViewController () {
    
    NSArray *imagesArray;
    NSSortDescriptor *sortDescriptor;
    NSOperationQueue *operationQueue;
    NSBlockOperation *operation;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@end

@implementation DetailsPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    operationQueue = [[NSOperationQueue alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.postImage setImage:[UIImage imageNamed:@"image"]];    //Setting the image in the detials view back to its default state.
    
    [self loadTheViewWithNewData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!operation.isFinished) {    //removing the unfinished operation from the queue.
        [operation cancel];
        operation = nil;
    }
    
    [self.postImage setImage:[UIImage imageNamed:@"image"]];
}

- (void)loadTheViewWithNewData {
    
    if (self.mediaDictionary[@"caption"] == nil || self.mediaDictionary[@"caption"] == [NSNull null]) {
        self.captionLabel.hidden = YES;
    } else {
        self.captionLabel.hidden = NO;
        self.captionLabel.text =  self.mediaDictionary[@"caption"];
    }
    
    imagesArray = (NSArray *)self.mediaDictionary[@"media-metadata"];
    
    sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    
    imagesArray = [imagesArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSString *imageURLString = [imagesArray[0] valueForKey:@"url"];     //Filtering out the highest resolution image available in the set of images.
    
    //Putting the downloading part of the image in the background.
    
    operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{        //Invoking the main queue so as to implement the UI changes.
                
                self.postImage.image = image;
                
                [self.activityIndicator setHidden:YES];
                [self.activityIndicator stopAnimating];
            });
        }
    }];
    
    [operationQueue addOperation:operation];
}



@end
