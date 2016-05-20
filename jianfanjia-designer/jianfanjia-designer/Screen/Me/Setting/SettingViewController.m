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
    
    self.sectionArr1 = @[
                         [EditCellItem createSelection:@"清除缓存" value:[self getCacheValue] placeholder:nil image:[UIImage imageNamed:@"icon_invite_friend"] tapBlock:^(EditCellItem *curItem) {
                             [self onClickClearCache:curItem];
                         }],
                         [EditCellItem createSelection:@"关于我们" value:nil placeholder:nil image:[UIImage imageNamed:@"icon_online_service"] tapBlock:^(EditCellItem *curItem) {
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = tableView.backgroundColor;
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
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清空缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];

    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        curItem.value = [self getCacheValue];
        [self.tableView reloadData];
    }];

    [alert addAction:cancel];
    [alert addAction:done];

    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)getCacheValue {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    return [@((cache.memoryCache.totalCost + cache.diskCache.totalCost) / 8) humSizeString];
}

@end
