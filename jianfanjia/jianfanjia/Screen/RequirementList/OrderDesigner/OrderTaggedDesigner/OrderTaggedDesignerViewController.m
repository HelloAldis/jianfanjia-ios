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
#define kScrollCellPadding 20

typedef NS_ENUM(NSInteger, OrderDesignerOrderType) {
    NormalOrder,
    ReplaceOrder,
};

@interface OrderTaggedDesignerViewController () <ReuseScrollViewProtocol>
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet TouchDelegateView *containerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) ReuseScrollView *scrollView;

@property (strong, nonatomic) Requirement *requirement;
@property (assign, nonatomic) OrderDesignerOrderType orderType;
@property (strong, nonatomic) NSString *toBeReplacedDesignerId;
@property (strong, nonatomic) RequirementDataManager *dataManager;

@end

@implementation OrderTaggedDesignerViewController

#pragma mark - init method
- (id)initWithRequirement:(Requirement *)requirement withOrderType:(OrderDesignerOrderType)type {
    if (self = [super init]) {
        _requirement = requirement;
        _orderType = type;
        _dataManager = [[RequirementDataManager alloc] init];
    }
    
    return self;
}

- (id)initWithRequirement:(Requirement *)requirement {
    return [self initWithRequirement:requirement withOrderType:NormalOrder];
}

- (id)initWithRequirement:(Requirement *)requirement withToBeReplacedDesigner:(NSString *)designerid {
    if (self = [self initWithRequirement:requirement withOrderType:ReplaceOrder]) {
        _toBeReplacedDesignerId = designerid;
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
    
    NSString *value = @"1";
    NSString *str = [NSString stringWithFormat:@"您可立即预约%@名匠心定制设计师", value];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName:kThemeColor,
                                   }
                           range:[str rangeOfString:value]];
    self.lblTitle.attributedText = attributedStr;
}

- (void)setupReuseCells {
    self.pageControl.numberOfPages = self.dataManager.recommendedDesigners.count;
    self.scrollView = [[ReuseScrollView alloc] initWithFrame:CGRectMake(kScrollViewLeft, 0, kScreenWidth - kScrollViewLeft * 2, kScreenHeight -kNavWithStatusBarHeight - CGRectGetHeight(self.lblTitle.frame) - CGRectGetHeight(self.pageControl.frame))];
    self.scrollView.items = self.dataManager.recommendedDesigners;
    self.scrollView.reuseDelegate = self;
    self.scrollView.padding = kScrollCellPadding;
    self.scrollView.clipsToBounds = NO;
    [self.containerView addSubview:self.scrollView];
    self.containerView.touchDelegateView = self.scrollView;
}

#pragma mark - reuse delegate
- (ReuseCell *)reuseCellFactory {
    TaggedDesignerInfoView *taggedDesignerInfoView = [TaggedDesignerInfoView taggedDesignerInfoView];
    [taggedDesignerInfoView initWithDoneBlock:^(NSString *designerid) {
        [self orderDesigner:designerid];
    }];
    
    return taggedDesignerInfoView;
}

- (void)reuseScrollViewDidChangePage:(ReuseScrollView *)scrollView toPage:(NSInteger)toPage {
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

- (void)orderDesigner:(NSString *)designerid {
    [HUDUtil showWait];
    if (self.orderType == NormalOrder) {
        OrderDesignder *orderDesigner = [[OrderDesignder alloc] init];
        orderDesigner.requirementid = self.requirement._id;
        orderDesigner.designerids = @[designerid];
        
        [API orderDesigner:orderDesigner success:^{
            [HUDUtil hideWait];
            [self clickBack];
        } failure:^{
            [HUDUtil hideWait];
        } networkError:^{
            [HUDUtil hideWait];
        }];
    } else {
        ReplaceOrderedDesigner *request = [[ReplaceOrderedDesigner alloc] init];
        request.requirementid = self.requirement._id;
        request.old_designerid = self.toBeReplacedDesignerId;
        request.replaced_designerid = designerid;
        
        [API replaceOrderedDesigner:request success:^{
            [HUDUtil hideWait];
            [self clickBack];
        } failure:^{
            [HUDUtil hideWait];
        } networkError:^{
            [HUDUtil hideWait];
        }];
    }
}

@end
