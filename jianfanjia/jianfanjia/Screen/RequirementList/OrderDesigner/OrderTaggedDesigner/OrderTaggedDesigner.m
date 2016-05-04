//
//  OrderTaggedDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "OrderTaggedDesigner.h"
#import "ReuseScrollView.h"
#import "TaggedDesignerInfoView.h"

#define kPadding 20

@interface OrderTaggedDesigner () <ReuseScrollViewProtocol>
@property (strong, nonatomic) ReuseScrollView *scrollView;

@end

@implementation OrderTaggedDesigner

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[ReuseScrollView alloc] initWithFrame:CGRectMake(-kPadding/2.0, kNavWithStatusBarHeight + 60, kScreenWidth + kPadding, kScreenHeight -kNavWithStatusBarHeight - kTabBarHeight - 60 - 75) items:5];
    self.scrollView.reuseDelegate = self;
    self.scrollView.padding = kPadding;
    self.scrollView.clipsToBounds = NO;
    [self.view addSubview:self.scrollView];
}

#pragma mark - reuse delegate
- (ReuseCell *)reuseCellFactory {
    return [TaggedDesignerInfoView taggedDesignerInfoView];
}

@end
