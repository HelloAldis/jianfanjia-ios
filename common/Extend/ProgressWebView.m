//
//  ProgressWebView.m
//  jianfanjia
//
//  Created by Karos on 16/2/22.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProgressWebView.h"

@implementation ProgressWebView

- (id)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (self = [super initWithFrame:frame configuration:configuration]) {
        UIProgressView *progressView = progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(0, 0, kScreenWidth, 1);
        
        [[self rac_valuesAndChangesForKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTuple *tuple) {
            [progressView setAlpha:1.0f];
            double progress = [tuple.first doubleValue];
            [progressView setProgress:progress animated:YES];
            
            if(progress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [progressView setProgress:0.0f animated:NO];
                }];
            }
        }];
        
        [self addSubview:progressView];
    }
    
    return self;
}

@end
