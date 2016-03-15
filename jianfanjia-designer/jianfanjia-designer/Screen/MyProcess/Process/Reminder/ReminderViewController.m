//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ReminderViewController.h"
#import "PurchaseNotificationCell.h"
#import "PostponeNotificationCell.h"
#import "ReminderDataManager.h"
#import "API.h"

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypePurchase,
    NotificationTypePostpone,
};

static NSString *PurchaseNotificationCellIdentifier = @"PurchaseNotificationCell";
static NSString *PostponeNotificationCellIdentifier = @"PostponeNotificationCell";

@interface ReminderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnNotifications;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *reminderIcons;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *selectedLines;
@property (weak, nonatomic) IBOutlet UIImageView *noNotificationImage;
@property (weak, nonatomic) IBOutlet UILabel *noNotificationLabel;

@property (assign, nonatomic) NotificationType currentNotificationType;
@property (strong ,nonatomic) ReminderDataManager *dataManager;
@property (strong ,nonatomic) NSString *processid;

@property (assign, nonatomic) BOOL isNeedToRefresh;
@property (copy ,nonatomic) void (^RefreshBlock)(NSString *type);

@end

@implementation ReminderViewController

#pragma mark - init method
- (id)initWithProcess:(NSString *)processid refreshBlock:(void(^)(NSString *type))RefreshBlock {
    if (self = [super init]) {
        _processid = processid;
        _RefreshBlock = RefreshBlock;
        _dataManager = [[ReminderDataManager alloc] init];
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"我的提醒";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
    [self.tableView registerNib:[UINib nibWithNibName:PurchaseNotificationCellIdentifier bundle:nil] forCellReuseIdentifier:PurchaseNotificationCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PostponeNotificationCellIdentifier bundle:nil] forCellReuseIdentifier:PostponeNotificationCellIdentifier];
    
    [self.reminderIcons enumerateObjectsUsingBlock:^(UIView* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setCornerRadius:obj.bounds.size.width / 2];
    }];
    
    @weakify(self);
    [self.btnNotifications enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [obj setExclusiveTouch:YES];
    }];
    
    [self switchToOtherButton:NotificationTypePurchase];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentNotificationType == NotificationTypePurchase) {
        return self.dataManager.notifications.count;
    } else {
        return self.dataManager.schedules.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentNotificationType == NotificationTypePurchase) {
        PurchaseNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:PurchaseNotificationCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NotificationCD *notification = self.dataManager.notifications[indexPath.row];
        [cell initWithNotification:[notification notification]];
        return cell;
    } else {
        PostponeNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:PostponeNotificationCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Notification *notification;
        if (indexPath.row < self.dataManager.notifications.count) {
            NotificationCD *notificationCD = self.dataManager.notifications[indexPath.row];
            notification = [notificationCD notification];
        }
        
        @weakify(self);
        [cell initWithSchedule:self.dataManager.schedules[indexPath.row] notification:notification refreshBlock:^(NSString *processid) {
            @strongify(self);
            [self refresh];

        }];
        return cell;
    }
}

#pragma mark - user actions
- (void)onClickButton:(UIButton *)button {
    [self switchToOtherButton:[self.btnNotifications indexOfObject:button]];
}

- (void)switchToOtherButton:(NSInteger)buttonIndex {
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        UIButton *lastButton = self.btnNotifications[self.currentNotificationType];
        lastButton.alpha = 0.5;
        UIView *lastSelectedLine = self.selectedLines[self.currentNotificationType];
        lastSelectedLine.alpha = 0;
        UIButton *selectedButton = self.btnNotifications[buttonIndex];
        selectedButton.alpha = 1;
        UIView *selectedLine = self.selectedLines[buttonIndex];
        selectedLine.alpha = 1;
    } completion:^(BOOL finished) {
        @strongify(self);
        NotificationType preNotificationType = self.currentNotificationType;
        self.currentNotificationType = buttonIndex;

        if (self.currentNotificationType == NotificationTypePurchase) {
            self.tableView.header = nil;
        } else {
            if (!self.tableView.header) {
                @weakify(self);
                self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    @strongify(self);
                    [self refresh];
                }];
            }
        }
        
        [self refresh];
    }];
}

#pragma mark - refresh notification
- (void)refresh {
    if (self.currentNotificationType == NotificationTypePurchase) {
        [self refreshPurchases];
    } else {
        [self refreshReschedules];
    }
}

- (void)refreshPurchases {
    [self.dataManager refreshNotificationWithProcess:self.processid type:kNotificationTypePurchase];
//    self.dataManager.notifications = [self descendNotifications:self.dataManager.notifications];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self showNoNotification:self.dataManager.notifications.count == 0 image:@"no_purchase_notification" text:@"您还没有采购提醒"];
}

- (void)refreshReschedules {
    GetRescheduleNotification *request = [[GetRescheduleNotification alloc] init];
    
    [API getRescheduleNotification:request success:^{
        [self.tableView.header endRefreshing];
        [self.dataManager refreshNotificationWithProcess:self.processid type:kNotificationTypeReschedule status:kNotificationStatusUnread];
        [self.dataManager refreshSchedule:self.processid];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self showNoNotification:self.dataManager.schedules.count == 0 image:@"no_reschedule_notification" text:@"您还没有延期提醒"];
    } failure:^{
        
    } networkError:^{
        
    }];
}

#pragma mark - util
- (void)showNoNotification:(BOOL)show image:(NSString *)image text:(NSString *)text {
    self.noNotificationImage.image = [UIImage imageNamed:image];
    self.noNotificationLabel.text = text;
    self.noNotificationImage.hidden = !show;
    self.noNotificationLabel.hidden = !show;
}

@end
