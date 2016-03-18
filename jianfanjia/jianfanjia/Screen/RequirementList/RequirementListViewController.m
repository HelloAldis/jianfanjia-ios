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

static NSString *requirementCellId = @"PubulishedRequirementCell";

@interface RequirementListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirement;

@property (strong, nonatomic) RequirementDataManager *requirementDataManager;
@property (assign, nonatomic) BOOL wasInBindPhoneProcess;

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
    [self refreshRequirements:YES];
    
    if (self.wasInBindPhoneProcess && [GVUserDefaults standardUserDefaults].phone) {
        self.wasInBindPhoneProcess = NO;
        [self onClickCreate:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 60, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"RequirementCell" bundle:nil] forCellReuseIdentifier:requirementCellId];
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshRequirements:NO];
    }];
}

- (void)switchViewToHide {
    if ([self.requirementDataManager.requirements count]) {
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

#pragma mark - nav
- (void)initNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCreate:)];
    self.navigationItem.rightBarButtonItem.tintColor = kFinishedColor;
    self.title = @"装修需求";
}

#pragma mark - actions
- (IBAction)onClickCreate:(id)sender {
    if (![GVUserDefaults standardUserDefaults].phone) {
        self.wasInBindPhoneProcess = YES;
        [ViewControllerContainer showBindPhone:BindPhoneEventOrderDesigner];
        return;
    }
    
    [ViewControllerContainer showRequirementCreate:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.requirementDataManager.requirements count];
}

#pragma mark - table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:requirementCellId forIndexPath:indexPath];
    [cell initWithRequirement:self.requirementDataManager.requirements[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRequirementellHeight;
}

#pragma mark - send request 
- (void)refreshRequirements:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }

    GetUserRequirement *getRequirements = [[GetUserRequirement alloc] init];
    
    [API getUserRequirement:getRequirements success:^{
        [HUDUtil hideWait];
        [self.tableView.header endRefreshing];
        [self.requirementDataManager refreshRequirementList];
        [self switchViewToHide];
        
        [self.tableView reloadData];
    } failure:^{
        [HUDUtil hideWait];
        [self.tableView.header endRefreshing];
    } networkError:^{
        [HUDUtil hideWait];
        [self.tableView.header endRefreshing];
    }];
}

@end
