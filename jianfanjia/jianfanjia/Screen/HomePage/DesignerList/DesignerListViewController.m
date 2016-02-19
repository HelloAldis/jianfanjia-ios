//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerListViewController.h"
#import "HomePageDesignerCell.h"
#import "DropdownMenuView.h"

typedef NS_ENUM(NSInteger, DesignFilterType) {
    DesignFilterTypeDecType,
    DesignFilterTypeHouseType,
    DesignFilterTypeStyle,
    DesignFilterTypeDesignFee,
};

static NSString *HomePageDesignerCellIdentifier = @"HomePageDesignerCell";

@interface DesignerListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *angleImages;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;

@property (strong, nonatomic) DropdownMenuView *dropdownMenu;
@property (assign, nonatomic) BOOL isShowDropdown;
@property (assign, nonatomic) DesignFilterType designFilterType;
@property (strong, nonatomic) NSString *curDesignFilterTypeDecType;
@property (strong, nonatomic) NSString *curDesignFilterTypeHouse;
@property (strong, nonatomic) NSString *curDesignFilterTypeStyle;
@property (strong, nonatomic) NSString *curDesignFilterTypeDesignFee;

@end

@implementation DesignerListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([DataManager shared].homePageNeedRefresh) {
        [self refresh:NO];
    }
}

#pragma mark - UI
- (void)initNav {
    self.title = @"全部设计师";
    [self initLeftBackInNav];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:HomePageDesignerCellIdentifier bundle:nil] forCellReuseIdentifier:HomePageDesignerCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh:NO];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    
    [self refresh:YES];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataManager shared].homePageDesigners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageDesignerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:HomePageDesignerCellIdentifier];
    [cell initWith:[[DataManager shared].homePageDesigners objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHomePageDesignerCellHeight;
}

- (void)refresh:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    
    HomePageDesigners *request = [[HomePageDesigners alloc] init];
    request.from = @0;
    request.limit = @10;
    
    @weakify(self);
    [API homePageDesigners:request success:^{
        @strongify(self);
        [DataManager shared].homePageNeedRefresh = NO;
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        [HUDUtil hideWait];
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
    [HUDUtil hideWait];
    if (self.tableView.header.isRefreshing) {
        [self.tableView.header endRefreshing];
    }
    
    if (self.tableView.footer.isRefreshing) {
        [self.tableView.footer endRefreshing];
    }
}

- (void)hanldeNetworkError {
    [HUDUtil hideWait];
    if (self.tableView.header.isRefreshing) {
        [self.tableView.header endRefreshing];
    }
    
    if (self.tableView.footer.isRefreshing) {
        [self.tableView.footer endRefreshing];
    }
}



@end
