//
//  ServiceManager.h
//  ECommerceApp
//
//  Created by Prateek Raj on 10/07/18.
//  Copyright © 2018 Prateek Raj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceManager : NSObject

+ (ServiceManager *) sharedInstance;

-(void)getDataFromServerwithCompletionBlock:(void (^)(id, NSError *))block;

@end
