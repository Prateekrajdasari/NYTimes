//
//  ServiceManager.m
//  ECommerceApp
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import "ServiceManager.h"

static ServiceManager *sharedInstance = nil;

@implementation ServiceManager

+ (ServiceManager *) sharedInstance {
    
    @synchronized([ServiceManager class]) {
        
        if (!sharedInstance) {
            
            sharedInstance = [[self alloc] init];
            
        }
        return sharedInstance;
    }
    return nil;
}

-(void)getDataFromServerwithCompletionBlock:(void (^)(id, NSError *))block {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=869d4e276804463b8b139a47809a8e4f"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    if (error) {
                                                        
                                                        NSLog(@"%@", error);
                                                        
                                                        if (block)
                                                            block (nil, error);
                                                    } else {
                                                       
                                                        NSJSONSerialization *responseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                        
                                                        NSArray *resultsArray = [(NSDictionary *)responseJson valueForKey:@"results"];

                                                       NSLog(@"%@", resultsArray);

                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            if (block)
                                                                block (resultsArray, nil);
                                                        });
                                                        
                                                        
                                                        
                                                    }
                                                }];
    [dataTask resume];
}


@end



























































