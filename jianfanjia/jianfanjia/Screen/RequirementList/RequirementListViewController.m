//
//  RequirementListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementListViewController.h"
#import "RequirementDataManager.h"
#import "RequirementCell.h"
#import "ViewControllerContainer.h"

static NSString *RequirementCellIdentifier = @"RequirementCell";

@interface RequirementListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirement;

@property (strong, nonatomic) RequirementDataManager *dataManager;

@end

@implementation RequirementListViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initNav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshRequirements:NO];
}

#pragma mark - init ui
- (void)initNav {
    self.title = @"我要装修";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataManager = [[RequirementDataManager alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 55, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    [self.tableView registerNib:[UINib nibWithNibName:RequirementCellIdentifier bundle:nil] forCellReuseIdentifier:RequirementCellIdentifier];
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshRequirements:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRequirementCreate) name:kRequirementCreateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogout) name:kLogoutNotification object:nil];
}

- (void)showRequirementList:(BOOL)show {
    if (show) {
        self.btnCreate.hidden = YES;
        self.lblNoRequirement.hidden = YES;
        self.imageView.hidden = YES;
        
        self.tableView.hidden = NO;
    } else {
        self.btnCreate.hidden = NO;
        self.lblNoRequirement.hidden = NO;
        self.imageView.hidden = NO;

        self.tableView.hidden = YES;
    }
}

- (void)handleRequirementCreate {
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}

- (void)handleLogout {
    self.dataManager.requirements = nil;
    [self.tableView reloadData];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataManager.requirements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:RequirementCellIdentifier forIndexPath:indexPath];
    [cell initWithRequirement:self.dataManager.requirements[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Requirement *requirement = self.dataManager.requirements[indexPath.row];
    
    __block NSInteger height = 286;
    if ([RequirementBusiness isDesignRequirement:requirement.work_type]) {
        [self.dataManager refreshOrderedDesigners:requirement];
        NSArray *orderedDesigners = self.dataManager.orderedDesigners;
        NSString *status = requirement.status;
        [StatusBlock matchReqt:status actions:
         @[[ReqtUnorderDesigner action:^{
                height = 286;
            }],
           [ReqtConfiguredAgreement action:^{
                height = 286;
            }],
           [ReqtPlanWasChoosed action:^{
                height = 286;
            }],
           [ElseStatus action:^{
                static NSArray *actionStatus;
                actionStatus = @[kPlanStatusDesignerRespondedWithoutMeasureHouse, kPlanStatusDesignerSubmittedPlan];
                
                __block NSInteger actionIndex = -1;
                [orderedDesigners enumerateObjectsUsingBlock:^(Designer *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *status = obj.plan.status;
                    if ([actionStatus containsObject:status]) {
                        actionIndex = idx;
                        *stop = YES;
                    }
                }];
                
                if (actionIndex != -1) {
                    height = 286;
                } else {
                    height = 239;
                }
            }],
           ]];
    }
    
    return height;
}

#pragma mark - send request
- (void)refreshRequirements:(BOOL)showPlsWait {
    if ([[LoginEngine shared] isLogin]) {
        if (showPlsWait) {
            [HUDUtil showWait];
        }
        
        GetUserRequirement *getRequirements = [[GetUserRequirement alloc] init];
        
        [API getUserRequirement:getRequirements success:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
            [self.dataManager refreshRequirementList];
            [self showRequirementList:self.dataManager.requirements.count > 0];
            
            [self.tableView reloadData];
        } failure:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
        } networkError:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
        }];
    } else {
        [self showRequirementList:NO];
    }
}

@end
