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

@property (assign, nonatomic) CGFloat preY;
@property (assign, nonatomic) BOOL isTabbarhide;

@end

@implementation RequirementListViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.requirementDataManager = [[RequirementDataManager alloc] init];
    
    [self initUI];
    [self initNav];
    self.preY = 0;
    self.isTabbarhide = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [[NotificationDataManager shared] observePurchaseUnreadCount:^(id value) {
        DDLogDebug(@"============== %@ ", value);
    } process:@"565522a171b1ff7478fbe922"];
    
    [self refreshRequirements];
    
    NSLog(@"%@", [GVUserDefaults standardUserDefaults].userid);
}

#pragma mark - init ui
- (void)initUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"RequirementCell" bundle:nil] forCellReuseIdentifier:requirementCellId];
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshRequirements];
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

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.preY > scrollView.contentOffset.y) {
        //下滑
        if (!self.tableView.footer.isRefreshing) {
            [self showTabbar];
        }
    } else if (self.preY < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
        //上滑
        [self hideTabbar];
        
    }
    
    NSInteger maxOffset = scrollView.contentSize.height - scrollView.bounds.size.height;
    //是否有滑动超过边界
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y > maxOffset) {
        self.preY = maxOffset;
    } else {
        self.preY = scrollView.contentOffset.y;
    }
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

#pragma mark - actions
- (IBAction)onClickCreate:(id)sender {
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
- (void)refreshRequirements {
    GetUserRequirement *getRequirements = [[GetUserRequirement alloc] init];
    
    [API getUserRequirement:getRequirements success:^{
        [self.tableView.header endRefreshing];
        [self.requirementDataManager refreshRequirementList];
        [self switchViewToHide];
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

@end
