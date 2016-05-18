//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MeViewController.h"
#import "SettingViewController.h"
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
@property (nonatomic, strong) NSArray *sectionArr2;
@property (nonatomic, strong) NSArray *sectionArr3;
@property (nonatomic, strong) NSArray *sectionArr4;

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
    [[NotificationDataManager shared] refreshUnreadCount];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"我的";
    
    UIButton *bellButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [bellButton setImage:[UIImage imageNamed:@"notification-bell"] forState:UIControlStateNormal];
    [bellButton addTarget:self action:@selector(onClickNotification) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bellButton];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:AvtarInfoCellIdentifier bundle:nil] forCellReuseIdentifier:AvtarInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:QuickLinkCellIdentifier bundle:nil] forCellReuseIdentifier:QuickLinkCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ConsultPhoneCellIdentifier bundle:nil] forCellReuseIdentifier:ConsultPhoneCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 60, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    [EditCellItem registerCells:self.tableView];
    
    self.sectionArr2 = @[
                         [EditCellItem createAttrSelection:[[NSAttributedString alloc] initWithString:@"设计师认证中心"] attrValue:[@"正在认证中" attrStrWithFont:[UIFont systemFontOfSize:14] color:kExcutionStatusColor] placeholder:nil image:[UIImage imageNamed:@"icon_designer_auth"] tapBlock:^(EditCellItem *curItem) {
                             [ViewControllerContainer showDesignerAuth];
                         }],
                         [EditCellItem createAttrSelection:[@"接单资料 (完善资料，提高接单精准度)" attrSubStr:@"(完善资料，提高接单精准度)" font:[UIFont systemFontOfSize:12] color:kThemeColor] attrValue:nil placeholder:nil image:[UIImage imageNamed:@"icon_service_material"] tapBlock:^(EditCellItem *curItem) {
                             
                         }],
                         ];
    
    self.sectionArr3 = @[
                         [EditCellItem createSelection:@"邀请好友" value:nil placeholder:nil image:[UIImage imageNamed:@"icon_invite_friend"] tapBlock:^(EditCellItem *curItem) {
                             
                         }],
                         [EditCellItem createSelection:@"意见反馈" value:nil placeholder:nil image:[UIImage imageNamed:@"icon_feedback"] tapBlock:^(EditCellItem *curItem) {
                             FeedbackViewController *v = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
                             [[ViewControllerContainer navigation] pushViewController:v animated:YES];
                         }],
                         [EditCellItem createSelection:@"在线客服" value:nil placeholder:nil image:[UIImage imageNamed:@"icon_online_service"] tapBlock:^(EditCellItem *curItem) {
                             [[ViewControllerContainer navigation] pushViewController:[CustomerServiceViewController instance] animated:YES];
                         }],
                         ];
    
    self.sectionArr4 = @[
                         [EditCellItem createSelection:@"设置" value:nil placeholder:nil image:[UIImage imageNamed:@"icon_setting"] tapBlock:^(EditCellItem *curItem) {
                             SettingViewController *v = [[SettingViewController alloc] init];
                             [[ViewControllerContainer navigation] pushViewController:v animated:YES];
                         }],
                         ];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = tableView.backgroundColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return self.sectionArr2.count;
    } else if (section == 2) {
        return self.sectionArr3.count;
    } else if (section == 3) {
        return self.sectionArr4.count;
    } else if (section == 4) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr2[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [self.sectionArr3[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [self.sectionArr4[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 4) {
        ConsultPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ConsultPhoneCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - user action
- (IBAction)onClickNotification {
    [ViewControllerContainer showMyNotification:NotificationTypeAll];
}

//
//- (IBAction)onClickClearCache:(id)sender {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清空缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //Do nothing
//    }];
//    
//    @weakify(self)
//    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        @strongify(self);
//        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
//        [cache.memoryCache removeAllObjects];
//        [cache.diskCache removeAllObjects];
////        [self updateCache];
//    }];
//    
//    [alert addAction:cancel];
//    [alert addAction:done];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//}
//

@end
