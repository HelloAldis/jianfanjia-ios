//
//  MyDeepLinkRouter.m
//  jianfanjia
//
//  Created by Karos on 16/7/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "MyDeepLinkRouter.h"

@implementation MyDeepLinkRouter

- (instancetype)init {
    if (self = [super init]) {
        [self configure];
    }
    
    return self;
}

- (void)configure {
    self[@"*"] = ^(DPLDeepLink *link) {
        [[[UIAlertView alloc] initWithTitle:@"逗比"
                                    message:link.URL.absoluteString
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    };
}

@end
