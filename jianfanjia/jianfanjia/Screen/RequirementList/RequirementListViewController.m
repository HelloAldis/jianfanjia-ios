//
//  RequirementListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementListViewController.h"
#import "RequirementCreateViewController.h"
#import "RequirementDataManager.h"
#import "RequirementCell.h"
#import "ViewControllerContainer.h"

static NSString *RequirementCellIdentifier = @"RequirementCell";

@interface RequirementListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirement;

@property (strong, nonatomic) RequirementDataManager *requirementDataManager;

@end

@implementation RequirementListViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.requirementDataManager = [[RequirementDataManager alloc] init];
    
    [self initUI];
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshRequirements:NO];
    [self showTabbar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        [self hideTabbar];
    }
}

#pragma mark - init ui
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 55, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    [self.tableView registerNib:[UINib nibWithNibName:RequirementCellIdentifier bundle:nil] forCellReuseIdentifier:RequirementCellIdentifier];
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshRequirements:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRequirementCreate) name:kRequirementCreateNotification object:nil];
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

#pragma mark - nav
- (void)initNav {
    self.title = @"我要装修";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCreate:)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

#pragma mark - actions
- (IBAction)onClickCreate:(id)sender {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            if (![GVUserDefaults standardUserDefaults].phone) {
                [ViewControllerContainer showBindPhone:BindPhoneEventPublishRequirement callback:^{
                    [ViewControllerContainer showRequirementCreate:nil];
                }];
            } else {
                [ViewControllerContainer showRequirementCreate:nil];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.requirementDataManager.requirements count];
}

#pragma mark - table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:RequirementCellIdentifier forIndexPath:indexPath];
    [cell initWithRequirement:self.requirementDataManager.requirements[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Requirement *requirement = self.requirementDataManager.requirements[indexPath.row];
    
    __block NSInteger height = 286;
    if ([RequirementBusiness isDesignRequirement:requirement.work_type]) {
        height = 241;
        [StatusBlock matchReqt:requirement.status action:[ReqtUnorderDesigner action:^{
            height = 286;
        }]];
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
            [self.requirementDataManager refreshRequirementList];
            [self showRequirementList:self.requirementDataManager.requirements.count > 0];
            
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
