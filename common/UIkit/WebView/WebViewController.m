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
        self.needShare = YES;
        self.canBack = YES;
    }
    
    return self;
}

- (void)onClickShare {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.articleImgUrl]]];
    [[ShareManager shared] share:self topic:self.topic image:image ? image : [UIImage imageNamed:@"about_logo"] title:![self.webView.title isEmpty] ? self.webView.title : DefaultTitle description:self.articleDescription ? self.articleDescription : @"我在使用 #简繁家# 的App，业内一线设计师为您量身打造房间，比传统装修便宜20%，让你一手轻松掌控装修全过程。" targetLink:self.webView.URL.absoluteString delegate:self];
}

@end
