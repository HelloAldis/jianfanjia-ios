//
//  SettingViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "CellEditComponent.h"
#import "LogoutCell.h"

static NSString *LogoutCellIdentifier = @"LogoutCell";

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionArr1;

@property (nonatomic, strong) EditCellItem *clearCacheItem;

@end

@implementation SettingViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"更多";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:LogoutCellIdentifier bundle:nil] forCellReuseIdentifier:LogoutCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    [EditCellItem registerCells:self.tableView];
    
    @weakify(self);
    self.sectionArr1 = @[
                         [EditCellItem createSelection:@"清除缓存" value:[self getCacheValue] allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_invite_friend"] tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             [self onClickClearCache:curItem];
                         }],
                         [EditCellItem createSelection:@"关于我们" value:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_online_service"] tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             AboutViewController *v = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
                             [self.navigationController pushViewController:v animated:YES];
                         }],
                         ];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionArr1.count;
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    } else if (indexPath.section == 1) {
        LogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:LogoutCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark - user action
- (void)onClickClearCache:(EditCellItem *)curItem {
    [AlertUtil show:self title:@"确定清空缓存？" cancelBlock:^{
        
    } doneBlock:^{
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        curItem.value = [self getCacheValue];
        [self.tableView reloadData];
    }];
}

- (NSString *)getCacheValue {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    return [@((cache.memoryCache.totalCost + cache.diskCache.totalCost) / 8) humSizeString];
}

@end
