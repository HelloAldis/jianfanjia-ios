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
    id escapedResponse = [self escapeResponse:response];
    dispatch_async(dispatch_get_main_queue(), ^{
        [DataManager shared].errMsg = [escapedResponse objectForKey:@"err_msg"];
        [DataManager shared].data = [escapedResponse objectForKey:@"data"];
        
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
    });
//    [DataManager shared].errMsg = nil;
//    [DataManager shared].data = nil;
}

- (void)handleHttpError:(NSError *)err networkError:(void (^)(void))error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUDUtil hideWait];
        [HUDUtil showErrText:@"网络不给力"];
        
        if (error) {
            error();
        }
        
        if ([err.localizedDescription containsString:@"403"]) {
            [ViewControllerContainer logout];
            [HUDUtil showErrText:@"登录过期, 请重新登录"];
        }
    });
}

- (id)escapeResponse:(id)response {
    NSError *serializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:response options:kNilOptions error:&serializationError];
    if (serializationError) {
        DDLogDebug(@"escapeResponse %@", serializationError);
        return nil;
    }
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    json = [StringUtil escapeHtml:json];
    data = [json dataUsingEncoding:NSUTF8StringEncoding];

    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
    if (serializationError) {
        DDLogDebug(@"escapeResponse %@", serializationError);
        return nil;
    }
    
    return responseObject;
}

@end
