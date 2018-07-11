//
//  NYTimesTests.m
//  NYTimesTests
//
//  Created by Prateek Raj on 11/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "ServiceManager.h"

@interface NYTimesTests : XCTestCase {
    
  
}

@property (nonatomic, strong) ViewController *vc;
@property (nonatomic, retain) ServiceManager *serviceManager;

@end

@implementation NYTimesTests

- (void)setUp {
    
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    self.serviceManager = [ServiceManager sharedInstance];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.vc = nil;
    [super tearDown];
}

#pragma mark - View loading tests
-(void)testThatViewLoads {
    
    XCTAssertNotNil(self.vc.view, @"View not initiated properly");
}

- (void)testParentViewHasTableViewSubview {
    
    NSArray *subviews = self.vc.view.subviews;
    XCTAssertTrue([subviews containsObject:self.vc.postsTableView], @"View does not have a table subview");
}

-(void)testThatTableViewLoads {
    
    XCTAssertNotNil(self.vc.postsTableView, @"TableView not initiated");
}

#pragma mark - UITableView tests
- (void)testForUITableViewDataSource {
    
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource {
    
    XCTAssertNotNil(self.vc.postsTableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testForUITableViewDelegate {
    
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate {
    
    XCTAssertNotNil(self.vc.postsTableView.delegate, @"Table delegate cannot be nil");
}

- (void)testTableViewHeightForRowAtIndexPath {
    
    CGFloat expectedHeight = 120.0;
    CGFloat actualHeight = self.vc.postsTableView.rowHeight;
    XCTAssertEqual(expectedHeight, actualHeight, @"Cell should have %f height, but they have %f", expectedHeight, actualHeight);
}

- (void)testForAPI {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=869d4e276804463b8b139a47809a8e4f"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    if (error) {
                                                        
                                                        NSLog(@"%@", error);
                                                        
                                                        XCTAssert(NO);
                                                    } else {
                                                        
                                                        XCTAssert(YES);
                                                    }
                                                }];
    [dataTask resume];
}



- (void)testForServerData {
    
    [self.serviceManager getDataFromServerwithCompletionBlock:^(id response, NSError *error) {
        
        if ([response isKindOfClass:[NSArray class]]) {
            
            XCTAssertNotNil(response,@"Server has return a nil object");
        }
    }];
}


@end
