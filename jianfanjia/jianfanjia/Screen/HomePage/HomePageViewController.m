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
#import "HomePagePackageCell.h"
#import "HomePageProductCell.h"
#import "HomePageDataManager.h"
#import "ViewControllerContainer.h"

static NSString *BannerCellIdentifier = @"BannerCell";
static NSString *HomePageQuickEntryCellIdentifier = @"HomePageQuickEntryCell";
static NSString *HomePagePackageCellIdentifier = @"HomePagePackageCell";
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
    [self initNav];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"简繁家";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_phone"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickCall)];
    self.navigationItem.leftBarButtonItem.tintColor = kThemeTextColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickSearch)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
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
    [self.tableView registerNib:[UINib nibWithNibName:HomePagePackageCellIdentifier bundle:nil] forCellReuseIdentifier:HomePagePackageCellIdentifier];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BannerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BannerCellIdentifier];
        return cell;
    } else if (indexPath.row == 1) {
        HomePageQuickEntryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:HomePageQuickEntryCellIdentifier];
        return cell;
    } else if (indexPath.row == 2) {
        HomePagePackageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:HomePagePackageCellIdentifier];
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
    }  else if (indexPath.row == 2) {
        return kHomePagePackageCellHeight;
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

- (void)onClickCall {
    [PhoneUtil call:@"咨询热线" phone:kConsultPhone];
}

@end
