//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "MyUserViewController.h"
#import "UnrespondActionCell.h"
#import "RejectActionCell.h"
#import "RespondedActionCell.h"
#import "MeasuredHouseActionCell.h"
#import "SubmitPlanExpiredActionCell.h"
#import "SubmitedPlanActionCell.h"
#import "ChoosedPlanActionCell.h"
#import "ChoosedPlanForDesignActionCell.h"
#import "UnchoosedPlanActionCell.h"
#import "MyUserDataManager.h"
#import "NoRequirementImageView.h"
#import "API.h"

typedef NS_ENUM(NSInteger, PlanType) {
    PlanTypeUnprocess,
    PlanTypeProcessing,
    PlanTypeProcessed,
};

static NSString *UnrespondActionCellIdentifier = @"UnrespondActionCell";
static NSString *RejectActionCellIdentifier = @"RejectActionCell";
static NSString *RespondedActionCellIdentifier = @"RespondedActionCell";
static NSString *MeasuredHouseActionCellIdentifier = @"MeasuredHouseActionCell";
static NSString *SubmitPlanExpiredActionCellIdentifier = @"SubmitPlanExpiredActionCell";
static NSString *SubmitedPlanActionCellIdentifier = @"SubmitedPlanActionCell";
static NSString *ChoosedPlanActionCellIdentifier = @"ChoosedPlanActionCell";
static NSString *ChoosedPlanForDesignActionCellIdentifier = @"ChoosedPlanForDesignActionCell";
static NSString *UnchoosedPlanActionCellIdentifier = @"UnchoosedPlanActionCell";

@interface MyUserViewController ()

@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (strong, nonatomic) NSMutableArray<UITableView *> *tableViews;
@property (strong, nonatomic) NSMutableArray<NoRequirementImageView *> *noRequirementViews;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnActions;

@property (assign, nonatomic) PlanType currentPlanType;
@property (strong ,nonatomic) MyUserDataManager *dataManager;

@property (assign, nonatomic) CGFloat preY;
@property (assign, nonatomic) BOOL isTabbarhide;
@property (assign, nonatomic) BOOL isFirstEnter;

@end

@implementation MyUserViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self refresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isTabbarhide) {
        [self showTabbar];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!self.isTabbarhide && self.navigationController.viewControllers.count > 1) {
        [self hideTabbar];
    }
}

#pragma mark - UI
- (void)initNav {
    self.title = @"我的业主";
}

- (void)initUI {
    self.preY = 0;
    self.isTabbarhide = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataManager = [[MyUserDataManager alloc] init];
    self.tableViews = [NSMutableArray array];
    self.noRequirementViews = [NSMutableArray array];
    CGFloat topDistance = 45 + 64;
    CGFloat bottomDistance = 50;
    CGFloat bettweenDistance = 4;
    CGFloat tableViewWidth = kScreenWidth - bettweenDistance;
    CGFloat tableViewHeight = kScreenHeight - topDistance - bottomDistance;
    
    self.pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topDistance, kScreenWidth, tableViewHeight)];
    self.pageScrollView.delegate = self;
    self.pageScrollView.backgroundColor = kViewBgColor;
    self.pageScrollView.bounces = NO;
    self.pageScrollView.alwaysBounceHorizontal = NO;
    self.pageScrollView.alwaysBounceVertical = NO;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.showsVerticalScrollIndicator = NO;
    self.pageScrollView.pagingEnabled = YES;
    [self.view addSubview:self.pageScrollView];
    
    @weakify(self);
    for (NSInteger i = 0; i < 3; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(bettweenDistance / 2 + i * (tableViewWidth + bettweenDistance), 0, tableViewWidth, tableViewHeight)];
        
        tableView.backgroundColor = kViewBgColor;
        tableView.tableFooterView = [[UIView alloc] init];
        [tableView registerNib:[UINib nibWithNibName:UnrespondActionCellIdentifier bundle:nil] forCellReuseIdentifier:UnrespondActionCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:RejectActionCellIdentifier bundle:nil] forCellReuseIdentifier:RejectActionCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:RespondedActionCellIdentifier bundle:nil] forCellReuseIdentifier:RespondedActionCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:MeasuredHouseActionCellIdentifier bundle:nil] forCellReuseIdentifier:MeasuredHouseActionCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:SubmitPlanExpiredActionCellIdentifier bundle:nil] forCellReuseIdentifier:SubmitPlanExpiredActionCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:SubmitedPlanActionCellIdentifier bundle:nil] forCellReuseIdentifier:SubmitedPlanActionCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:ChoosedPlanActionCellIdentifier bundle:nil] forCellReuseIdentifier:ChoosedPlanActionCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:ChoosedPlanForDesignActionCellIdentifier bundle:nil] forCellReuseIdentifier:ChoosedPlanForDesignActionCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:UnchoosedPlanActionCellIdentifier bundle:nil] forCellReuseIdentifier:UnchoosedPlanActionCellIdentifier];
        
        NoRequirementImageView *noRequirementView = [NoRequirementImageView noRequirementImageView];
        noRequirementView.frame = CGRectMake(0, 0, kScreenWidth, tableViewHeight);
        [tableView addSubview:noRequirementView];
        
        [self.pageScrollView addSubview:tableView];
        [self.tableViews addObject:tableView];
        [self.noRequirementViews addObject:noRequirementView];
        
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refresh:NO];
        }];
        
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    [self.pageScrollView setContentSize:CGSizeMake(kScreenWidth * 3, tableViewHeight)];
    
    [self.btnActions enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [obj setExclusiveTouch:YES];
    }];
}

#pragma mark - scroll view deleate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pageScrollView) {
        NSInteger idx = self.pageScrollView.contentOffset.x / kScreenWidth;
        if (idx != self.currentPlanType) {
            [self switchToOtherButton:idx isClicked:NO];
        }
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentPlanType == PlanTypeUnprocess && self.tableViews[PlanTypeUnprocess] == tableView) {
        return self.dataManager.unprocessActions.count;
    } else if (self.currentPlanType == PlanTypeProcessing && self.tableViews[PlanTypeProcessing] == tableView) {
        return self.dataManager.processingActions.count;
    } else if (self.tableViews[PlanTypeProcessed] == tableView) {
        return self.dataManager.processedActions.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Requirement *requirement;
    if (self.currentPlanType == PlanTypeUnprocess && self.tableViews[PlanTypeUnprocess] == tableView) {
        requirement = self.dataManager.unprocessActions[indexPath.row];
    } else if (self.currentPlanType == PlanTypeProcessing && self.tableViews[PlanTypeProcessing] == tableView) {
        requirement = self.dataManager.processingActions[indexPath.row];
    } else if (self.tableViews[PlanTypeProcessed] == tableView) {
        requirement = self.dataManager.processedActions[indexPath.row];
    }
    
    BaseActionCell *cell = [self loadCell:requirement tableView:tableView forIndex:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Requirement *requirement;
    if (self.currentPlanType == PlanTypeUnprocess && self.tableViews[PlanTypeUnprocess] == tableView) {
        requirement = self.dataManager.unprocessActions[indexPath.row];
    } else if (self.currentPlanType == PlanTypeProcessing && self.tableViews[PlanTypeProcessing] == tableView) {
        requirement = self.dataManager.processingActions[indexPath.row];
    } else if (self.tableViews[PlanTypeProcessed] == tableView) {
        requirement = self.dataManager.processedActions[indexPath.row];
    }
    
    NSString *status = requirement.plan.status;
    if ([status isEqualToString:kPlanStatusExpiredAsDesignerDidNotProvidePlanInSpecifiedTime]) {
        return 96;
    }
    
    return 146;
}

- (BaseActionCell *)loadCell:(Requirement *)requirement tableView:(UITableView *)tableView forIndex:(NSIndexPath *)path {
    NSString *status = requirement.plan.status;
    
    NSString *cellIdentifier;
    if ([status isEqualToString:kPlanStatusHomeOwnerOrderedWithoutResponse]) {
        cellIdentifier = UnrespondActionCellIdentifier;
    } else if ([status isEqualToString:kPlanStatusDesignerRespondedWithoutMeasureHouse]) {
        cellIdentifier = RespondedActionCellIdentifier;
    } else if ([status isEqualToString:kPlanStatusDesignerSubmittedPlan]) {
        cellIdentifier = SubmitedPlanActionCellIdentifier;
    } else if ([status isEqualToString:kPlanStatusPlanWasChoosed]) {
        NSString *work_type = requirement.work_type;
        cellIdentifier = [work_type isEqualToString:kWorkTypeDesign] ? ChoosedPlanForDesignActionCellIdentifier : ChoosedPlanActionCellIdentifier;
    } else if ([status isEqualToString:kPlanStatusDesignerDeclineHomeOwner]) {
        cellIdentifier = RejectActionCellIdentifier;
    } else if ([status isEqualToString:kPlanStatusPlanWasNotChoosed]) {
        cellIdentifier = UnchoosedPlanActionCellIdentifier;
    } else if ([status isEqualToString:kPlanStatusDesignerMeasureHouseWithoutPlan]) {
        cellIdentifier = MeasuredHouseActionCellIdentifier;
    }  else {
        cellIdentifier = SubmitPlanExpiredActionCellIdentifier;
    }
    
    BaseActionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:path];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self);
    [cell initWithRequirement:requirement actionBlock:^{
        @strongify(self);
        [self refresh:NO];
    }];
    return cell;
}

#pragma mark - user actions
- (void)onClickButton:(UIButton *)button {
    NSInteger idx = [self.btnActions indexOfObject:button];
    [self switchToOtherButton:idx isClicked:YES];
}

- (void)switchToOtherButton:(NSInteger)buttonIndex isClicked:(BOOL)isClicked {
    NSInteger prePlanType = self.currentPlanType;
    self.currentPlanType = buttonIndex;
    [self switchViewToHide];
    [[self getCurrentTableView] reloadData];
    
    CGFloat offsetX = self.pageScrollView.contentOffset.x;
    NSInteger curIdx = offsetX / kScreenWidth;
    
    if (curIdx != buttonIndex && isClicked) {
        [self.pageScrollView setContentOffset:CGPointMake(kScreenWidth * buttonIndex, 0) animated:YES];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *lastButton = self.btnActions[prePlanType];
        lastButton.alpha = 0.5;
        UIButton *selectedButton = self.btnActions[self.currentPlanType];
        selectedButton.alpha = 1;
        
        [self endAllTableViewRefreshing];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - refresh notification
- (void)refresh:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    DesignerGetUserRequirements *request = [[DesignerGetUserRequirements alloc] init];
    
    [API designerGetUserRequirement:request success:^{
        [self endAllTableViewRefreshing];
        [HUDUtil hideWait];
        [self.dataManager refreshAllActions];
        [self reloadData];
    } failure:^{
        [self endAllTableViewRefreshing];
        [HUDUtil hideWait];
    } networkError:^{
        [self endAllTableViewRefreshing];
        [HUDUtil hideWait];
    }];
}

#pragma mark - Util
- (UITableView *)getCurrentTableView {
    return self.tableViews[self.currentPlanType];
}

- (void)endAllTableViewRefreshing {
    [self.tableViews enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.header endRefreshing];
    }];
}

- (void)hideTabbar {
    if (!self.isTabbarhide) {
        self.isTabbarhide = YES;
        [UIView animateWithDuration:0.6 animations:^{
            self.tabBarController.tabBar.frame = CGRectOffset(self.tabBarController.tabBar.frame, 0, 50);
        }];
    }
}

- (void)showTabbar {
    if (self.isTabbarhide) {
        self.isTabbarhide = NO;
        [UIView animateWithDuration:0.6 animations:^{
            self.tabBarController.tabBar.frame = CGRectOffset(self.tabBarController.tabBar.frame, 0, -50);
        }];
    }
}

- (void)reloadData {
    if (!self.isFirstEnter) {
        self.isFirstEnter = YES;
        
        [self switchToSuitableButton];
    } else {
        [self switchViewToHide];
        [[self getCurrentTableView] reloadData];
    }
}

- (void)switchToSuitableButton {
    if (self.dataManager.unprocessActions.count > 0) {
        [self switchToOtherButton:PlanTypeUnprocess isClicked:YES];
    } else if (self.dataManager.processingActions.count > 0) {
        [self switchToOtherButton:PlanTypeProcessing isClicked:YES];
    } else if (self.dataManager.processedActions.count > 0) {
        [self switchToOtherButton:PlanTypeProcessed isClicked:YES];
    } else {
        [self switchToOtherButton:PlanTypeUnprocess isClicked:YES];
    }
}

- (void)switchViewToHide {
    if (self.currentPlanType == PlanTypeUnprocess && self.dataManager.unprocessActions.count == 0) {
        [self showNoRequirementImage:YES title:@"您暂时没有待响应的需求"];
    } else if (self.currentPlanType == PlanTypeProcessing && self.dataManager.processingActions.count == 0) {
        [self showNoRequirementImage:YES title:@"您暂时没有进行中的需求"];
    } else if (self.currentPlanType == PlanTypeProcessed && self.dataManager.processedActions.count == 0) {
        [self showNoRequirementImage:YES title:@"您暂时没有已放弃的需求"];
    } else {
        [self showNoRequirementImage:NO title:nil];
    }
}

- (void)showNoRequirementImage:(BOOL)show title:(NSString *)title {
    NoRequirementImageView *noRequirementView = self.noRequirementViews[self.currentPlanType];
    
    [UIView animateWithDuration:0.3 animations:^{
        noRequirementView.alpha = show ? 1 : 0;
        noRequirementView.lblNoRequirementTitle.text = title;
        noRequirementView.lblNoRequirementDesc.text = @"温馨提示：如您的资料完善程度高，系统将会优先将您推给业主\n\n网址：http://www.jianfanjia.com/";
    } completion:nil];
}

@end
