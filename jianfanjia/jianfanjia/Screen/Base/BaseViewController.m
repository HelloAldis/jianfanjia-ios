//
//  BaseViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/5.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.navigationController) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    });
}

- (void)didReceiveMemoryWarning {
    DDLogError(@"didReceiveMemoryWarning");
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - UI
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (void)initLeftBackInNav {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)initTranslucentNavBar {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"translucent"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - user actions
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBack {
    [self onClickBack];
}

@end
