//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HomePageViewController.h"
#import "BannerCell.h"
#import "HomePageRecDesignersCell.h"
#import "HomePageRequirementCell.h"
#import "HomePageDesignerCell.h"

@interface HomePageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CGFloat preY;
@property (assign, nonatomic) BOOL isTabbarhide;

@end

@implementation HomePageViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageRequirementCell" bundle:nil] forCellReuseIdentifier:@"HomePageRequirementCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageRecDesignersCell" bundle:nil] forCellReuseIdentifier:@"HomePageRecDesignersCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageDesignerCell" bundle:nil] forCellReuseIdentifier:@"HomePageDesignerCell"];
    
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    
    self.preY = 0;
    self.isTabbarhide = NO;
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNav];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isTabbarhide) {
        [self showTabbar];
    }
    
    if ([DataManager shared].homePageNeedRefresh) {
        [self refresh];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self hasRequirement] && ![self hasRequirementDesigners]) {
        return 1 + [DataManager shared].homePageDesigners.count;
    } else {
        return 2 + [DataManager shared].homePageDesigners.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BannerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BannerCell"];
        return cell;
    } else if (indexPath.row == 1) {
        if ([self hasRequirement]) {
            if ([self hasRequirementDesigners]) {
                HomePageRecDesignersCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HomePageRecDesignersCell"];
                [cell initWithDesigners:[DataManager shared].homePageRequirementDesigners];
                return cell;
            } else {
                HomePageDesignerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HomePageDesignerCell"];
                [cell initWith:[[DataManager shared].homePageDesigners objectAtIndex:indexPath.row - 1]];
                return cell;
            }
        } else {
            HomePageRequirementCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HomePageRequirementCell"];
            return cell;
        }
    } else {
        NSInteger index = 0;
        if ([self hasRequirement] && ![self hasRequirementDesigners]) {
            index = indexPath.row - 1;
        } else {
            index = indexPath.row - 2;
        }
        
        HomePageDesignerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HomePageDesignerCell"];
        [cell initWith:[[DataManager shared].homePageDesigners objectAtIndex:index]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kBannerCellHeight;
    } else if (indexPath.row == 1) {
        if ([self hasRequirement] && ![self hasRequirementDesigners]) {
            return kHomePageDesignerCellHeight;
        } else {
            return kHomePageRequirementCellHeight;
        }
    } else {
        return kHomePageDesignerCellHeight;
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.preY > scrollView.contentOffset.y) {
        //上滑
        if (!self.tableView.footer.isRefreshing) {
            [self showTabbar];
        }
    } else if (self.preY < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
        //下滑
        [self hideTabbar];
    }
    
    self.preY = scrollView.contentOffset.y;
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

- (BOOL)hasRequirement {
    return [DataManager shared].homePageRequirement ? YES : NO;
}

- (BOOL)hasRequirementDesigners {
    return [DataManager shared].homePageRequirementDesigners.count > 0;
}

- (void)refresh {
    HomePageDesigners *request = [[HomePageDesigners alloc] init];
    request.from = @0;
    request.limit = @10;
    
    @weakify(self);
    [API homePageDesigners:request success:^{
        @strongify(self);
        [DataManager shared].homePageNeedRefresh = NO;
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failure:^{
        @strongify(self);
        [self hanldeFailure];
    } networkError:^{
        @strongify(self);
        [self hanldeNetworkError];
    }];
}

- (void)loadMore {
    HomePageDesigners *request = [[HomePageDesigners alloc] init];
    request.from = @([DataManager shared].homePageDesigners.count);
    request.limit = @10;
    
    @weakify(self);
    [API homePageDesigners:request success:^{
        @strongify(self);
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^{
        @strongify(self);
        [self hanldeFailure];
    } networkError:^{
        @strongify(self);
        [self hanldeNetworkError];
    }];
}

- (void)hanldeFailure {
    if (self.tableView.header.isRefreshing) {
        [self.tableView.header endRefreshing];
    }
    
    if (self.tableView.footer.isRefreshing) {
        [self.tableView.footer endRefreshing];
    }
}

- (void)hanldeNetworkError {
    if (self.tableView.header.isRefreshing) {
        [self.tableView.header endRefreshing];
    }
    
    if (self.tableView.footer.isRefreshing) {
        [self.tableView.footer endRefreshing];
    }
}



@end
