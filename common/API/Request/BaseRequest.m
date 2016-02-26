//
//  BaseRequest.m
//  AURA
//
//  Created by KindAzrael on 14-10-11.
//  Copyright (c) 2014年 AURA. All rights reserved.
//

#import "BaseRequest.h"
#import "ViewControllerContainer.h"

@implementation BaseRequest


- (void)pre {

}

- (void)all {
    [HUDUtil hideWait];
}

- (void)failure {
    
}

- (void)success {
    
}

- (void)handle:(id)response success:(void (^)(void))success failure:(void (^)(void))failure {
    [DataManager shared].errMsg = [response objectForKey:@"err_msg"];
    [DataManager shared].data = [response objectForKey:@"data"];

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
    
    [DataManager shared].errMsg = nil;
    [DataManager shared].data = nil;
}

- (void)handleHttpError:(NSError *)err networkError:(void (^)(void))error {
    [HUDUtil hideWait];
    [HUDUtil showErrText:@"网络不给力"];
    
    if (error) {
        error();
    }
    
    if ([err.localizedDescription containsString:@"403"]) {
        [ViewControllerContainer logout];
        [HUDUtil showErrText:@"登录过期, 请重新登录"];
    }
}

@end
