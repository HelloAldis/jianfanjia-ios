//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HomePageViewController.h"
#import "BannerCell.h"
#import "HomePageQuickEntryCell.h"
#import "HomePageProductCell.h"
#import "HomePageDataManager.h"
#import "ViewControllerContainer.h"

static NSString *BannerCellIdentifier = @"BannerCell";
static NSString *HomePageQuickEntryCellIdentifier = @"HomePageQuickEntryCell";
static NSString *HomePageProductCellIdentifier = @"HomePageProductCell";

@interface HomePageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isTabbarhide;
@property (assign, nonatomic) BOOL isShowProduct;

@property (strong, nonatomic) HomePageDataManager *dataManager;

@end

@implementation HomePageViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDefaultNavBarStyle];
    [self initNav];
}

#pragma mark - UI
- (void)initNav {
//    self.tabBarController.title = @"简繁家";
//    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickSearch)];
//    self.tabBarController.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
//    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataManager = [[HomePageDataManager alloc] init];
    self.isTabbarhide = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.tableView registerNib:[UINib nibWithNibName:BannerCellIdentifier bundle:nil] forCellReuseIdentifier:BannerCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:HomePageQuickEntryCellIdentifier bundle:nil] forCellReuseIdentifier:HomePageQuickEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:HomePageProductCellIdentifier bundle:nil] forCellReuseIdentifier:HomePageProductCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh:NO];
    }];
    
    [self.tableView reloadData];
    [self refresh:NO];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BannerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BannerCellIdentifier];
        return cell;
    } else if (indexPath.row == 1) {
        HomePageQuickEntryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:HomePageQuickEntryCellIdentifier];
        return cell;
    } else {
        HomePageProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:HomePageProductCellIdentifier];
        [cell initWithProducts:self.dataManager.homeProducts isShowProduct:self.isShowProduct];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kBannerCellHeight;
    } else if (indexPath.row == 1) {
        return kHomePageQuickEntryCellHeight;
    } else {
        return kHomePageProductCellHeight;
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat productOffsetY = contentHeight - kScreenHeight + kTabBarHeight;
    CGPoint curOffset = scrollView.contentOffset;
    
    if (!self.isShowProduct && curOffset.y > -kNavWithStatusBarHeight) {
        self.isShowProduct = YES;
        [self.tableView reloadData];
        targetOffset = CGPointMake(curOffset.x, productOffsetY);
        targetContentOffset->x = targetOffset.x;
        targetContentOffset->y = targetOffset.y;
    } else if (self.isShowProduct) {
        if (curOffset.y < productOffsetY) {
            self.isShowProduct = NO;
            [self.tableView reloadData];
            targetOffset = CGPointMake(curOffset.x, -kNavWithStatusBarHeight);
            targetContentOffset->x = targetOffset.x;
            targetContentOffset->y = targetOffset.y;
        }
    }
}

#pragma mark - user action
- (void)refresh:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    
    GetTopProducts *request = [[GetTopProducts alloc] init];
    request.limit = @(50);
    [API getTopProducts:request success:^{
        [self.tableView.header endRefreshing];
        [self.dataManager refresh];
        [self.tableView reloadData];
        [HUDUtil hideWait];
    } failure:^{
        [self.tableView.header endRefreshing];
        [HUDUtil hideWait];
    } networkError:^{
        [self.tableView.header endRefreshing];
        [HUDUtil hideWait];
    }];
}

- (void)onClickSearch {
    [ViewControllerContainer showSearch];
}

@end
