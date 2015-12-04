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
#import "API.h"
#import "ReminderDataManager.h"

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypePurchase,
    NotificationTypePay,
    NotificationTypePostpone,
};

static NSString *PurchaseNotificationCellIdentifier = @"PurchaseNotificationCell";
static NSString *PayNotificationCellIdentifier = @"PayNotificationCell";
static NSString *PostponeNotificationCellIdentifier = @"PostponeNotificationCell";

@interface ReminderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnNotifications;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *reminderIcons;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *selectedLines;

@property (assign, nonatomic) NSInteger selectedButtonIndex;
@property (assign, nonatomic) NotificationType currentNotificationType;
@property (strong ,nonatomic) ReminderDataManager *dataManager;

@end

@implementation ReminderViewController

#pragma mark - init method
- (id)init {
    if (self = [super init]) {
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
    }];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    [self switchToOtherButton:0];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentNotificationType == NotificationTypePurchase) {
        return 6;
    } else if (self.currentNotificationType == NotificationTypePay) {
        return 5;
    } else {
        return self.dataManager.schedules.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentNotificationType == NotificationTypePurchase) {
        PurchaseNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:PurchaseNotificationCellIdentifier forIndexPath:indexPath];
        return cell;
    } else if (self.currentNotificationType == NotificationTypePay) {
        PayNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:PayNotificationCellIdentifier forIndexPath:indexPath];
        return cell;
    } else {
        PostponeNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:PostponeNotificationCellIdentifier forIndexPath:indexPath];
        [cell initWithSchedule:self.dataManager.schedules[indexPath.row]];
        return cell;
    }
}

#pragma mark - user actions
- (void)onClickButton:(UIButton *)button {
    [self switchToOtherButton:[self.btnNotifications indexOfObject:button]];
}

- (void)switchToOtherButton:(NSInteger)buttonIndex {
    if (self.selectedButtonIndex == buttonIndex) {
        UIButton *selectedButton = self.btnNotifications[buttonIndex];
        selectedButton.alpha = 1;
        UIView *selectedLine = self.selectedLines[buttonIndex];
        selectedLine.alpha = 1;
        return;
    }
    
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
        self.selectedButtonIndex = buttonIndex;
        self.currentNotificationType = buttonIndex;
        [self refresh];
    }];
}

#pragma mark - refresh notification
- (void)refresh {
    if (self.currentNotificationType == NotificationTypePurchase) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (self.currentNotificationType == NotificationTypePay) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self refreshReschedules];
    }
}

- (void)refreshReschedules {
    GetRescheduleNotification *request = [[GetRescheduleNotification alloc] init];
    
    [API getRescheduleNotification:request success:^{
        [self.tableView.header endRefreshing];
        [self.dataManager refreshSchedule];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^{
        
    }];
}

@end
