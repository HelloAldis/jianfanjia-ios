//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MeViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "ViewControllerContainer.h"
#import "CustomerServiceViewController.h"
#import "CellEditComponent.h"
#import "AvtarInfoCell.h"
#import "QuickLinkCell.h"
#import "ConsultPhoneCell.h"

static NSString *AvtarInfoCellIdentifier = @"AvtarInfoCell";
static NSString *QuickLinkCellIdentifier = @"QuickLinkCell";
static NSString *ConsultPhoneCellIdentifier = @"ConsultPhoneCell";

@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionArr1;
@property (nonatomic, strong) NSArray *sectionArr2;

@property (assign, nonatomic) CGRect originUserImageFrame;
@property (assign, nonatomic) CGRect originAvatarImageFrame;

@end

@implementation MeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
//    if (CGRectGetHeight(self.originUserImageFrame) == 0) {
//        self.originUserImageFrame = self.userImageView.frame;
//    }
}

#pragma mark - UI
- (void)initNav {
    self.title = @"我的";
    
    UIButton *bellButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [bellButton setImage:[UIImage imageNamed:@"notification-bell"] forState:UIControlStateNormal];
    [bellButton addTarget:self action:@selector(onClickNotification) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bellButton];
    
    [[NotificationDataManager shared] subscribeMyNotificationUnreadCount:^(NSInteger count) {
        self.navigationItem.rightBarButtonItem.badgeNumber = count > 0 ? kBadgeStyleDot : @"";
    }];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:AvtarInfoCellIdentifier bundle:nil] forCellReuseIdentifier:AvtarInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:QuickLinkCellIdentifier bundle:nil] forCellReuseIdentifier:QuickLinkCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ConsultPhoneCellIdentifier bundle:nil] forCellReuseIdentifier:ConsultPhoneCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 60, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [EditCellItem registerCells:self.tableView];
    
    @weakify(self);
    self.sectionArr1 = @[
                         [EditCellItem createAttrSelection:[@"清空缓存" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:[self getCacheValue] allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_feedback"] tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             [self onClickClearCache:curItem];
                         }],
                         [EditCellItem createAttrSelection:[@"意见反馈" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_feedback"] tapBlock:^(EditCellItem *curItem) {
                             FeedbackViewController *v = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
                             [[ViewControllerContainer navigation] pushViewController:v animated:YES];
                         }],
                         [EditCellItem createAttrSelection:[@"在线客服" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_online_service"] tapBlock:^(EditCellItem *curItem) {
                             [[ViewControllerContainer navigation] pushViewController:[CustomerServiceViewController instance] animated:YES];
                         }],
                         ];
    
    self.sectionArr2 = @[
                         [EditCellItem createAttrSelection:[@"更多" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_setting"] tapBlock:^(EditCellItem *curItem) {
                             AboutViewController *v = [[AboutViewController alloc] init];
                             [[ViewControllerContainer navigation] pushViewController:v animated:YES];
                         }],
                         ];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return self.sectionArr1.count;
    } else if (section == 2) {
        return self.sectionArr2.count;
    } else if (section == 3) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                AvtarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:AvtarInfoCellIdentifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell initUI];
                return cell;
            } else if (indexPath.row == 1) {
                QuickLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:QuickLinkCellIdentifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [self.sectionArr2[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    } else if (indexPath.section == 3) {
        ConsultPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ConsultPhoneCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kAvtarInfoCellHeight;
        } else if (indexPath.row == 1) {
            return kQuickLinkCellHeight;
        }
    } else if (indexPath.section == 1) {
        return [self.sectionArr1[indexPath.row] cellheight];
    } else if (indexPath.section == 2) {
        return [self.sectionArr2[indexPath.row] cellheight];
    } else if (indexPath.section == 3) {
        return kConsultPhoneCellHeight;
    }
    
    return 0.0;
}

#pragma mark - user action
- (void)onClickNotification {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            [ViewControllerContainer showMyNotification:NotificationTypeAll];
        }
    }];
}

//
//#pragma mark - scroll view  delegate 
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    CGRect f = CGRectZero;
//    f.origin.y = offsetY;
//    f.size.width = MAX(kScreenWidth, kScreenWidth - offsetY);
//    f.size.height =  CGRectGetHeight(self.originUserImageFrame) - offsetY;
//    f.origin.x = MIN(0, offsetY / 2);
//    self.userImageView.frame = f;
//}
//

#pragma mark - other
- (void)onClickClearCache:(EditCellItem *)curItem {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清空缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        curItem.attrValue = [self getCacheValue];

        [self.tableView reloadData];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSMutableAttributedString *)getCacheValue {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    NSString *number = [@((cache.memoryCache.totalCost + cache.diskCache.totalCost) / 8) humSizeString];
    
    return [number attrStrWithFont:[UIFont systemFontOfSize:14] color:kTextColor];
}

@end
