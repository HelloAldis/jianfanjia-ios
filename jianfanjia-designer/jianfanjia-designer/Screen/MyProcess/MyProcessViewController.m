//
//  RequirementListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MyProcessViewController.h"
#import "RequirementCreateViewController.h"
#import "ProcessDataManager.h"
#import "ProcessCell.h"
#import "ViewControllerContainer.h"

static NSString *ProcessCellId = @"ProcessCell";

@interface MyProcessViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirement;

@property (strong, nonatomic) ProcessDataManager *dataManager;

@property (assign, nonatomic) CGFloat preY;
@property (assign, nonatomic) BOOL isTabbarhide;

@end

@implementation MyProcessViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataManager = [[ProcessDataManager alloc] init];
    
    [self initUI];
    [self initNav];
    self.preY = 0;
    self.isTabbarhide = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    [self refreshProcessList:YES];
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

#pragma mark - init ui
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 210;
    [self.tableView registerNib:[UINib nibWithNibName:ProcessCellId bundle:nil] forCellReuseIdentifier:ProcessCellId];
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshProcessList:NO];
    }];
}

#pragma mark - nav
- (void)initNav {
    self.title = @"工地管理";
}

#pragma mark - scroll view delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.preY > scrollView.contentOffset.y) {
//        //下滑
//        if (!self.tableView.footer.isRefreshing) {
//            [self showTabbar];
//        }
//    } else if (self.preY < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
//        //上滑
//        [self hideTabbar];
//        
//    }
//    
//    NSInteger maxOffset = scrollView.contentSize.height - scrollView.bounds.size.height;
//    //是否有滑动超过边界
//    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y > maxOffset) {
//        self.preY = maxOffset;
//    } else {
//        self.preY = scrollView.contentOffset.y;
//    }
//}

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

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataManager.processList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:ProcessCellId forIndexPath:indexPath];
    [cell initWithProcess:self.dataManager.processList[indexPath.row]];
    
    return cell;
}

#pragma mark - send request 
- (void)refreshProcessList:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }

    GetDesignerProcess *getProcesss = [[GetDesignerProcess alloc] init];
    
    [API getDesignerProcess:getProcesss success:^{
        [HUDUtil hideWait];
        [self.tableView.header endRefreshing];
        [self.dataManager refreshProcessList];
        
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
