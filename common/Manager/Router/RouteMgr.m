//
//  RouteMgr.m
//  jianfanjia
//
//  Created by Karos on 16/7/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "RouteMgr.h"

@interface RouteMgr ()

@end

@implementation RouteMgr

- (BOOL)handleURL:(NSURL *)url {
    return [self.router handleURL:url withCompletion:^(BOOL handled, NSError *error) {
        DDLogDebug(@"handleURL handled:%@ error:%@", [NSNumber numberWithBool:handled], error);
    }];
}

- (BOOL)handleUserActivity:(NSUserActivity *)userActivity {
    return [self.router handleUserActivity:userActivity withCompletion:^(BOOL handled, NSError *error) {
        DDLogDebug(@"handleUserActivity handled:%@ error:%@", [NSNumber numberWithBool:handled], error);
    }];
}

+ (instancetype)shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
