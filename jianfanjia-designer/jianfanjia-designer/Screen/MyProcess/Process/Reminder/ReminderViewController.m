//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ReminderViewController.h"
#import "PurchaseNotificationCell.h"
#import "PayNotificationCell.h"
#import "PostponeNotificationCell.h"
#import "ReminderDataManager.h"
#import "API.h"

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypePostpone,
    NotificationTypePurchase,
    NotificationTypePay,
};

static NSString *PurchaseNotificationCellIdentifier = @"PurchaseNotificationCell";
static NSString *PayNotificationCellIdentifier = @"PayNotificationCell";
static NSString *PostponeNotificationCellIdentifier = @"PostponeNotificationCell";

@interface ReminderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnNotifications;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *reminderIcons;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *selectedLines;

@property (assign, nonatomic) NSInteger preSelectedButtonIndex;
@property (assign, nonatomic) NSInteger selectedButtonIndex;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    @weakify(self);
    if (self.processid) {
        [[NotificationDataManager shared] subscribeUnreadCountForProcess:self.processid type:kNotificationTypePurchase observer:^(id value) {
            @strongify(self);
            [self.btnNotifications[0] setBadgeValue:[value intValue] > 0 ? [value stringValue] : nil];
        }];
        
        [[NotificationDataManager shared] subscribeUnreadCountForProcess:self.processid type:kNotificationTypePay observer:^(id value) {
            @strongify(self);
            [self.btnNotifications[1] setBadgeValue:[value intValue] > 0 ? [value stringValue] : nil];
        }];
        
        [[NotificationDataManager shared] subscribeUnreadCountForProcess:self.processid type:kNotificationTypeReschedule observer:^(id value) {
            @strongify(self);
            [self.btnNotifications[2] setBadgeValue:[value intValue] > 0 ? [value stringValue] : nil];
        }];
    } else  {
        [[NotificationDataManager shared] subscribePurchaseUnreadCount:^(id value) {
            @strongify(self);
            [self.btnNotifications[0] setBadgeValue:[value intValue] > 0 ? [value stringValue] : nil];
        }];
        
        [[NotificationDataManager shared] subscribePayUnreadCount:^(id value) {
            @strongify(self);
            [self.btnNotifications[1] setBadgeValue:[value intValue] > 0 ? [value stringValue] : nil];
        }];
        
        [[NotificationDataManager shared] subscribeRescheduleUnreadCount:^(id value) {
            @strongify(self);
            [self.btnNotifications[2] setBadgeValue:[value intValue] > 0 ? [value stringValue] : nil];
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSString *badgeValue = [self.btnNotifications[self.selectedButtonIndex] badgeValue];
    if ([badgeValue intValue] > 0) {
        [self markToReadForProcess:self.processid type:[NSString stringWithFormat:@"%@", @(self.currentNotificationType)]];
    }
    
    if (self.isNeedToRefresh && self.RefreshBlock) {
        NSString *notificationType;
        switch (self.currentNotificationType) {
            case NotificationTypePay:
                notificationType = kNotificationTypePay;
                break;
            case NotificationTypePostpone:
                notificationType = kNotificationTypeReschedule;
                break;
            case NotificationTypePurchase:
                notificationType = kNotificationTypePurchase;
                break;
                
            default:
                break;
        }
        
        self.RefreshBlock(notificationType);
    }
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
    [self.tableView registerNib:[UINib nibWithNibName:PayNotificationCellIdentifier bundle:nil] forCellReuseIdentifier:PayNotificationCellIdentifier];
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
    
    [self switchToOtherButton:0];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentNotificationType == NotificationTypePurchase) {
        return self.dataManager.notifications.count;
    } else if (self.currentNotificationType == NotificationTypePay) {
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
    } else if (self.currentNotificationType == NotificationTypePay) {
        PayNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:PayNotificationCellIdentifier forIndexPath:indexPath];
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
            [self markToReadForProcess:processid type:kNotificationTypeReschedule];

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
        UIButton *lastButton = self.btnNotifications[self.selectedButtonIndex];
        lastButton.alpha = 0.5;
        UIView *lastSelectedLine = self.selectedLines[self.selectedButtonIndex];
        lastSelectedLine.alpha = 0;
        UIButton *selectedButton = self.btnNotifications[buttonIndex];
        selectedButton.alpha = 1;
        UIView *selectedLine = self.selectedLines[buttonIndex];
        selectedLine.alpha = 1;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.preSelectedButtonIndex = self.selectedButtonIndex;
        self.selectedButtonIndex = buttonIndex;
        
        if (self.preSelectedButtonIndex != self.selectedButtonIndex) {
            NSString *badgeValue = [self.btnNotifications[self.preSelectedButtonIndex] badgeValue];
            if ([badgeValue intValue] > 0) {
                [self markToReadForProcess:self.processid type:[NSString stringWithFormat:@"%@", @(self.currentNotificationType)]];
            }
        }
        
        if (buttonIndex == 0) {
            self.currentNotificationType = NotificationTypePurchase;
        } else if (buttonIndex == 1) {
            self.currentNotificationType = NotificationTypePay;
        } else if (buttonIndex == 2) {
            self.currentNotificationType = NotificationTypePostpone;
        }

        if (self.currentNotificationType == NotificationTypePurchase) {
            self.tableView.header = nil;
        } else if (self.currentNotificationType == NotificationTypePay) {
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
    } else if (self.currentNotificationType == NotificationTypePay) {
        [self refreshPays];
    } else {
        [self refreshReschedules];
    }
}

- (void)refreshPurchases {
    [self.dataManager refreshNotificationWithProcess:self.processid type:kNotificationTypePurchase];
    self.dataManager.notifications = [self descendNotifications:self.dataManager.notifications];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refreshPays {
    [self.dataManager refreshNotificationWithProcess:self.processid type:kNotificationTypePay];
    self.dataManager.notifications = [self descendNotifications:self.dataManager.notifications];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refreshReschedules {
    GetRescheduleNotification *request = [[GetRescheduleNotification alloc] init];
    
    [API getRescheduleNotification:request success:^{
        [self.tableView.header endRefreshing];
        [self.dataManager refreshNotificationWithProcess:self.processid type:kNotificationTypeReschedule status:kNotificationStatusUnread];
        [self.dataManager refreshSchedule:self.processid];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)markToReadForProcess:(NSString *)processid type:(NSString *)type {
    if (processid) {
        [[NotificationDataManager shared] markToReadForProcess:processid type:type];
    } else {
        [[NotificationDataManager shared] markToReadForType:type];
    }

    if ([type isEqualToString:kNotificationTypeReschedule] || [type isEqualToString:kNotificationTypePurchase]) {
        self.isNeedToRefresh = YES;
    }
}

- (NSArray *)descendNotifications:(NSArray *)notifications {
    return [notifications sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NotificationCD*  _Nonnull obj1, NotificationCD*  _Nonnull obj2) {
        if ([obj1.time compare:obj2.time] == NSOrderedAscending) {
            return NSOrderedDescending;
        } else if ([obj1.time compare:obj2.time] == NSOrderedDescending) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
}

@end