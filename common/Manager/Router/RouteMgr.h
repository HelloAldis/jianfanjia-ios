//
//  RouteMgr.h
//  jianfanjia
//
//  Created by Karos on 16/7/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DeepLinkKit/DeepLinkKit.h>

@interface RouteMgr : NSObject

@property (nonatomic, strong) DPLDeepLinkRouter *router;

- (BOOL)handleURL:(NSURL *)url;
- (BOOL)handleUserActivity:(NSUserActivity *)userActivity;

+ (instancetype)shared;

@end
