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

@property (nonatomic, strong) Designer *designer;

@property (nonatomic, strong) NSArray *sectionArr2;
@property (nonatomic, strong) NSArray *sectionArr3;
@property (nonatomic, strong) NSArray *sectionArr4;

@property (nonatomic, strong) EditCellItem *authCenterItem;

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
    [self refreshInfo];
    [[NotificationDataManager shared] refreshUnreadCount];
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
    
    self.authCenterItem = [EditCellItem createAttrSelection:[@"设计师认证中心" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_designer_auth"] tapBlock:^(EditCellItem *curItem) {
        [ViewControllerContainer showDesignerAuth];
    }];
    [self updateAuthCenter];
    
    @weakify(self)
    self.sectionArr2 = @[
                         self.authCenterItem,
                         [EditCellItem createAttrSelection:[@"接单资料 (完善资料，提高接单精准度)" attrSubStr1:@"接单资料" font1:[UIFont systemFontOfSize:14] color1:kThemeTextColor subStr2:@"(完善资料，提高接单精准度)" font2:[UIFont systemFontOfSize:12] color2:kThemeColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_service_material"] tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             [ViewControllerContainer showServiceArea:self.designer];
                         }],
                         ];
    
    self.sectionArr3 = @[
                         [EditCellItem createAttrSelection:[@"邀请好友" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_invite_friend"] tapBlock:^(EditCellItem *curItem) {
                             NSString *description = @"我在使用 #简繁家# 的App，业内一线设计师为您量身打造房间，比传统装修便宜20%，让你一手轻松掌控装修全过程。";
                             [[ShareManager shared] share:self topic:ShareTopicApp image:[UIImage imageNamed:@"about_logo"] title:@"简繁家，让装修变简单" description:description targetLink:@"http://www.jianfanjia.com/zt/mobile/index.html" delegate:self];
                         }],
                         [EditCellItem createAttrSelection:[@"意见反馈" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_feedback"] tapBlock:^(EditCellItem *curItem) {
                             FeedbackViewController *v = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
                             [[ViewControllerContainer navigation] pushViewController:v animated:YES];
                         }],
                         [EditCellItem createAttrSelection:[@"在线客服" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_online_service"] tapBlock:^(EditCellItem *curItem) {
                             [[ViewControllerContainer navigation] pushViewController:[CustomerServiceViewController instance] animated:YES];
                         }],
                         ];
    
    self.sectionArr4 = @[
                         [EditCellItem createAttrSelection:[@"设置" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeTextColor] attrValue:nil allowsEdit:YES placeholder:nil image:[UIImage imageNamed:@"icon_setting"] tapBlock:^(EditCellItem *curItem) {
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
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
            [cell initWithDeisgner:self.designer];
            return cell;
        } else if (indexPath.row == 1) {
            QuickLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:QuickLinkCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr2[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [self.sectionArr3[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [self.sectionArr4[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    } else if (indexPath.section == 4) {
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
        return [self.sectionArr2[indexPath.row] cellheight];
    } else if (indexPath.section == 2) {
        return [self.sectionArr3[indexPath.row] cellheight];
    } else if (indexPath.section == 3) {
        return [self.sectionArr4[indexPath.row] cellheight];
    } else if (indexPath.section == 4) {
        return kConsultPhoneCellHeight;
    }
    
    return 0.0;
}

#pragma mark - user action
- (void)onClickNotification {
    [ViewControllerContainer showMyNotification:NotificationTypeAll];
}

#pragma mark - api request
- (void)refreshInfo {
    DesignerGetInfo *request = [[DesignerGetInfo alloc] init];
    [API designerGetInfo:request success:^{
        self.designer = [[Designer alloc] initWith:[DataManager shared].data];
        [self updateAuthCenter];
        [self.tableView reloadData];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)updateAuthCenter {
    CGFloat progress = [DesignerBusiness getDesignerAuthProgress];
    NSString *progressZeroStr = @"请前往认证";
    NSString *progressStr = [NSString stringWithFormat:@"已完成认证 %@%%", @(progress * 100)];
    
    self.authCenterItem.attrValue = [progress > 0? progressStr : progressZeroStr attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeColor];
}

@end
