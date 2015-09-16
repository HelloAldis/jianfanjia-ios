//
//  BaseRequest.m
//  AURA
//
//  Created by KindAzrael on 14-10-11.
//  Copyright (c) 2014年 AURA. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest


- (void)pre {
    [DataManager shared].errMsg = nil;
    [DataManager shared].response = nil;
}

- (void)all {
    
}

- (void)failure {
    
}

- (void)success {
    
}

- (void)handle:(id)response success:(void (^)(void))success failure:(void (^)(void))failure {
    [DataManager shared].response = response;
    [DataManager shared].errMsg = [response objectForKey:@"err_msg"];
    
    [self all];
    if ([DataManager shared].errMsg) {
        [self failure];
        if (failure) {
            failure();
        }
    } else {
        [self success];
        if (success) {
            success();
        }
    }
}

- (void)handleHttpError:(NSError *)err failure:(void (^)(void))failure {
    DDLogDebug(@"http error %@", err);
}

@end
