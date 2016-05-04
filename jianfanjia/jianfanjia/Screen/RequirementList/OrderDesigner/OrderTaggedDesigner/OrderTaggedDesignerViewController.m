//
//  OrderTaggedDesigner.m
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "OrderTaggedDesignerViewController.h"
#import "ReuseScrollView.h"
#import "TouchDelegateView.h"
#import "TaggedDesignerInfoView.h"
#import "RequirementDataManager.h"

#define kScrollViewLeft 40

@interface OrderTaggedDesignerViewController () <ReuseScrollViewProtocol>
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet TouchDelegateView *containerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) ReuseScrollView *scrollView;

@property (strong, nonatomic) Requirement *requirement;
@property (strong, nonatomic) RequirementDataManager *dataManager;

@end

@implementation OrderTaggedDesignerViewController

- (id)initWithRequirement:(Requirement *)requirement {
    if (self = [super init]) {
        _requirement = requirement;
        _dataManager = [[RequirementDataManager alloc] init];
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
    [self refreshOrderableList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.clipsToBounds = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.scrollView.clipsToBounds = YES;
}

#pragma mark - init ui
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"匠心定制";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupReuseCells {
    self.scrollView = [[ReuseScrollView alloc] initWithFrame:CGRectMake(kScrollViewLeft, 0, kScreenWidth - kScrollViewLeft * 2, kScreenHeight -kNavWithStatusBarHeight - CGRectGetHeight(self.lblTitle.frame) - CGRectGetHeight(self.pageControl.frame)) items:self.dataManager.recommendedDesigners.count];
    self.scrollView.reuseDelegate = self;
    self.scrollView.clipsToBounds = NO;
    [self.containerView addSubview:self.scrollView];
    self.containerView.touchDelegateView = self.scrollView;
}

#pragma mark - reuse delegate
- (ReuseCell *)reuseCellFactory {
    TaggedDesignerInfoView *taggedDesignerInfoView = [TaggedDesignerInfoView taggedDesignerInfoView];
    [taggedDesignerInfoView initWithDesigners:self.dataManager.recommendedDesigners];
    
    return taggedDesignerInfoView;
}

- (void)reuseScrollViewPageDidChange:(ReuseScrollView *)scrollView toPage:(NSInteger)toPage {
    self.pageControl.currentPage = toPage;
}

#pragma mark - send request
- (void)refreshOrderableList {
    GetOrderableDesigners *request = [[GetOrderableDesigners alloc] init];
    request.requirementid = self.requirement._id;
    
    [API getOrderableDesigners:request success:^{
        [self.dataManager refreshOrderableDesigners];
        [self setupReuseCells];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
