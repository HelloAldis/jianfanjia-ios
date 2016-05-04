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

#define kScrollViewTop 60
#define kScrollViewLeft 40
#define kScrollViewBottom 75
#define kCellPadding 0

@interface OrderTaggedDesigner () <ReuseScrollViewProtocol>
@property (strong, nonatomic) ReuseScrollView *scrollView;

@end

@implementation OrderTaggedDesigner

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.clipsToBounds = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.scrollView.clipsToBounds = YES;
}

- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"匠心定制";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[ReuseScrollView alloc] initWithFrame:CGRectMake(kScrollViewLeft, kNavWithStatusBarHeight + kScrollViewTop, kScreenWidth - kScrollViewLeft * 2, kScreenHeight -kNavWithStatusBarHeight - kScrollViewTop - kScrollViewBottom) items:5];
    self.scrollView.reuseDelegate = self;
    self.scrollView.padding = kCellPadding;
    [self.view addSubview:self.scrollView];
}

#pragma mark - reuse delegate
- (ReuseCell *)reuseCellFactory {
    return [TaggedDesignerInfoView taggedDesignerInfoView];
}

@end
