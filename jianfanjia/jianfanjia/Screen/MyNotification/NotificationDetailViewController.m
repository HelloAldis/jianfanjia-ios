//
//  NotificationDetailViewController.m
//  jianfanjia
//
//  Created by Karos on 16/3/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "NotificationDetailViewController.h"

@interface NotificationDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NotificationDetailViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"通知详情";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
}

@end
