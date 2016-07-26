//
//  AgreementViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "WebViewController.h"
#import <SafariServices/SafariServices.h>
#import <Foundation/Foundation.h>

@implementation WebViewController

+ (void)show:(UIViewController *)controller withUrl:(NSString *)url shareTopic:(NSString *)topic {
    WebViewController *webview = [[WebViewController alloc] initWithUrl:url shareTopic:topic];
    [controller.navigationController pushViewController:webview animated:YES];
}

- (id)initWithUrl:(NSString *)url shareTopic:(NSString *)topic {
    if (self = [super init]) {
        self.url = url;
        self.topic = topic;
        self.needShare = topic.length > 0;
        self.canBack = YES;
    }
    
    return self;
}

@end
