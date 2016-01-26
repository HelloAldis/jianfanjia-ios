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

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnActions;
@property (weak, nonatomic) IBOutlet UIView *noRequirementView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirementTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirementDesc;

@property (assign, nonatomic) NSInteger preSelectedButtonIndex;
@property (assign, nonatomic) NSInteger selectedButtonIndex;
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
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:UnrespondActionCellIdentifier bundle:nil] forCellReuseIdentifier:UnrespondActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:RejectActionCellIdentifier bundle:nil] forCellReuseIdentifier:RejectActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:RespondedActionCellIdentifier bundle:nil] forCellReuseIdentifier:RespondedActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:MeasuredHouseActionCellIdentifier bundle:nil] forCellReuseIdentifier:MeasuredHouseActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:SubmitPlanExpiredActionCellIdentifier bundle:nil] forCellReuseIdentifier:SubmitPlanExpiredActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:SubmitedPlanActionCellIdentifier bundle:nil] forCellReuseIdentifier:SubmitedPlanActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ChoosedPlanActionCellIdentifier bundle:nil] forCellReuseIdentifier:ChoosedPlanActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ChoosedPlanForDesignActionCellIdentifier bundle:nil] forCellReuseIdentifier:ChoosedPlanForDesignActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:UnchoosedPlanActionCellIdentifier bundle:nil] forCellReuseIdentifier:UnchoosedPlanActionCellIdentifier];
    
    @weakify(self);
    [self.btnActions enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [obj setExclusiveTouch:YES];
    }];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh:NO];
    }];
}

#pragma mark - scroll view deleate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.noRequirementView.alpha == 1 && scrollView.contentOffset.y <= 0) {
        self.noRequirementView.frame = CGRectMake(self.noRequirementView.frame.origin.x, 109 - scrollView.contentOffset.y, self.noRequirementView.frame.size.width, self.noRequirementView.frame.size.height);
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentPlanType == PlanTypeUnprocess) {
        return self.dataManager.unprocessActions.count;
    } else if (self.currentPlanType == PlanTypeProcessing) {
        return self.dataManager.processingActions.count;
    } else {
        return self.dataManager.processedActions.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Requirement *requirement;
    if (self.currentPlanType == PlanTypeUnprocess) {
        requirement = self.dataManager.unprocessActions[indexPath.row];
    } else if (self.currentPlanType == PlanTypeProcessing) {
        requirement = self.dataManager.processingActions[indexPath.row];
    } else {
        requirement = self.dataManager.processedActions[indexPath.row];
    }
    
    BaseActionCell *cell = [self loadCell:requirement tableView:tableView forIndex:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Requirement *requirement;
    if (self.currentPlanType == PlanTypeUnprocess) {
        requirement = self.dataManager.unprocessActions[indexPath.row];
    } else if (self.currentPlanType == PlanTypeProcessing) {
        requirement = self.dataManager.processingActions[indexPath.row];
    } else {
        requirement = self.dataManager.processedActions[indexPath.row];
    }
    
    NSString *status = requirement.plan.status;
    if ([status isEqualToString:SubmitPlanExpiredActionCellIdentifier]) {
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
    [self switchToOtherButton:[self.btnActions indexOfObject:button]];
}

- (void)switchToOtherButton:(NSInteger)buttonIndex {
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *lastButton = self.btnActions[self.selectedButtonIndex];
        lastButton.alpha = 0.5;
        UIButton *selectedButton = self.btnActions[buttonIndex];
        selectedButton.alpha = 1;
    } completion:^(BOOL finished) {
        self.selectedButtonIndex = buttonIndex;
        self.currentPlanType = buttonIndex;
        [self switchViewToHide];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - refresh notification
- (void)refresh:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    DesignerGetUserRequirements *request = [[DesignerGetUserRequirements alloc] init];
    
    [API designerGetUserRequirement:request success:^{
        [HUDUtil hideWait];
        [self.tableView.header endRefreshing];
        [self.dataManager refreshAllActions];
        [self switchToSuitableButton];
    } failure:^{
        [self.tableView.header endRefreshing];
        [HUDUtil hideWait];
    } networkError:^{
        [self.tableView.header endRefreshing];
        [HUDUtil hideWait];
    }];
}

#pragma mark - Util
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

- (void)switchToSuitableButton {
    if (!self.isFirstEnter) {
        self.isFirstEnter = YES;
        
        if (self.dataManager.unprocessActions.count > 0) {
            [self switchToOtherButton:PlanTypeUnprocess];
        } else if (self.dataManager.processingActions.count > 0) {
            [self switchToOtherButton:PlanTypeProcessing];
        } else if (self.dataManager.processedActions.count > 0) {
            [self switchToOtherButton:PlanTypeProcessed];
        } else {
            [self switchToOtherButton:PlanTypeUnprocess];
        }
    } else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    [UIView animateWithDuration:0.3 animations:^{
        self.lblNoRequirementTitle.text = title;
        self.lblNoRequirementDesc.text = @"温馨提示：如您的资料完善程度高，系统将会优先将您推给业主\n\n网址：http://www.jianfanjia.com/";
        self.noRequirementView.alpha = show ? 1 : 0;
        self.tableView.backgroundColor = !show ? [UIColor colorWithR:240 g:240 b:240 a:1] : [UIColor colorWithR:240 g:240 b:240 a:0];
    } completion:nil];
}

@end
