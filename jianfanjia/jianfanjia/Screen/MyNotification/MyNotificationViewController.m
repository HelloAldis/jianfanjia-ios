//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "MyNotificationViewController.h"
#import "SystemAnnouncementCell.h"
#import "RequirementNotificationCell.h"
#import "WorksiteNotificationCell.h"
#import "MyNotificationDataManager.h"
#import "ViewControllerContainer.h"
#import "API.h"

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypeAll,
    NotificationTypeAnnouncement,
    NotificationTypeRequirement,
    NotificationTypeWorksite,
};

static NSString *SystemAnnouncementCellIdentifier = @"SystemAnnouncementCell";
static NSString *RequirementNotificationCellIdentifier = @"RequirementNotificationCell";
static NSString *WorksiteNotificationCellIdentifier = @"WorksiteNotificationCell";

@interface MyNotificationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnNotifications;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *reminderIcons;
@property (weak, nonatomic) IBOutlet UIView *selectedLine;

@property (weak, nonatomic) IBOutlet UIImageView *noNotificationImage;
@property (weak, nonatomic) IBOutlet UILabel *noNotificationLabel;

@property (assign, nonatomic) NotificationType currentNotificationType;
@property (strong ,nonatomic) MyNotificationDataManager *dataManager;
@property (strong ,nonatomic) NSArray *dataSource;
@property (strong ,nonatomic) NSArray *filter;

@end

@implementation MyNotificationViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"我的通知";
}

- (void)initUI {
    self.dataManager = [[MyNotificationDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 83;
    self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:SystemAnnouncementCellIdentifier bundle:nil] forCellReuseIdentifier:SystemAnnouncementCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:RequirementNotificationCellIdentifier bundle:nil] forCellReuseIdentifier:RequirementNotificationCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:WorksiteNotificationCellIdentifier bundle:nil] forCellReuseIdentifier:WorksiteNotificationCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    self.tableView.header.ignoredScrollViewContentInsetTop = 6;
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    
    [self.btnNotifications enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [obj setExclusiveTouch:YES];
    }];
    
    [self switchButton:self.currentNotificationType forceRefresh:YES];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserNotification *notification = self.dataSource[indexPath.row];
    NSString *type = notification.message_type;
    
    if ([NotificationBusiness contains:type inFilter:[NotificationBusiness userSystemAnnouncementFilter]]) {
        SystemAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemAnnouncementCellIdentifier forIndexPath:indexPath];
        [cell initWithNotification:notification];
        
        return cell;
    } else if ([NotificationBusiness contains:type inFilter:[NotificationBusiness userRequirmentNotificationFilter]]) {
        RequirementNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:RequirementNotificationCellIdentifier forIndexPath:indexPath];
        [cell initWithNotification:notification];
        
        return cell;
    } else if ([NotificationBusiness contains:type inFilter:[NotificationBusiness userWorksiteNotificationFilter]]) {
        WorksiteNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:WorksiteNotificationCellIdentifier forIndexPath:indexPath];
        [cell initWithNotification:notification];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserNotification *notification = self.dataSource[indexPath.row];
    [ViewControllerContainer showNotificationDetail:notification._id readBlock:^{
        notification.status = kNotificationStatusReaded;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - user actions
- (void)onClickButton:(UIButton *)button {
    [self switchButton:[self.btnNotifications indexOfObject:button] forceRefresh:NO];
}

- (void)switchButton:(NSInteger)buttonIndex forceRefresh:(BOOL)forceRefresh {
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        UIButton *lastButton = self.btnNotifications[self.currentNotificationType];
        UIButton *selectedButton = self.btnNotifications[buttonIndex];
        
        CGRect f = self.selectedLine.frame;
        f.origin.x = buttonIndex * CGRectGetWidth(f);
        self.selectedLine.frame = f;
        
        lastButton.alpha = 0.5;
        selectedButton.alpha = 1;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.currentNotificationType = buttonIndex;
        [self refreshDatasource];
        
        [self.tableView reloadData];
//        if (forceRefresh || self.dataSource.count == 0) {
            [self refresh];
//        }
    }];
}

- (void)refreshDatasource {
    switch (self.currentNotificationType) {
        case NotificationTypeAll:
            self.filter = [NotificationBusiness userAllNotificationsFilter];
            self.dataSource = self.dataManager.allNotifications;
            break;
        case NotificationTypeAnnouncement:
            self.filter = [NotificationBusiness userSystemAnnouncementFilter];
            self.dataSource = self.dataManager.systemAnnouncements;
            break;
        case NotificationTypeRequirement:
            self.filter = [NotificationBusiness userRequirmentNotificationFilter];
            self.dataSource = self.dataManager.requirmentNotifications;
            break;
        case NotificationTypeWorksite:
            self.filter = [NotificationBusiness userWorksiteNotificationFilter];
            self.dataSource = self.dataManager.worksiteNotifications;
            break;
            
        default:
            break;
    }
}

#pragma mark - refresh notification
- (void)refresh {
    [self.tableView.footer resetNoMoreData];
    
    void (^RefreshDataBlock)() = ^{
        [self refreshData:self.currentNotificationType];
    };
    
    SearchUserNotification *request = [SearchUserNotification requestWithTypes:self.filter];
    request.from = @(0);
    request.limit = @(20);
    
    [API searchUserNotification:request success:^{
        [self.tableView.header endRefreshing];
        RefreshDataBlock();
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)refreshData:(NotificationType)type {
    [self resetNoDataTip];
    
    NSString *noDataText;
    NSInteger count;
    switch (type) {
        case NotificationTypeAll: {
                count = [self.dataManager refreshAllNotifications];
                noDataText = @"您还没有任何通知";
            }
            break;
        case NotificationTypeAnnouncement: {
                count = [self.dataManager refreshSystemAnnouncements];
                noDataText = @"当前还没有系统公告";
            }
            break;
        case NotificationTypeRequirement: {
                count = [self.dataManager refreshRequirmentNotifications];
                noDataText = @"您还没有需求相关的通知";
            }
            break;
        case NotificationTypeWorksite: {
                count = [self.dataManager refreshWorksiteNotifications];
                noDataText = @"您还没有工地相关的通知";
            }
            break;
            
        default:
            break;
    }
    
    if (count == 0) {
        [self handleNoData:noDataText];
    } else if (count < 20) {
        [self.tableView.footer endRefreshingWithNoMoreData];
    }
    
    [self refreshDatasource];
    [self.tableView reloadData];
}

- (void)loadMore {
    void (^LoadMoreDataBlock)() = ^{
        [self loadMoreData:self.currentNotificationType];
    };
    
    SearchUserNotification *request = [SearchUserNotification requestWithTypes:self.filter];
    request.from = @(self.dataSource.count);
    request.limit = @(20);
    
    [API searchUserNotification:request success:^{
        [self.tableView.footer endRefreshing];
        LoadMoreDataBlock();
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}

- (void)loadMoreData:(NotificationType)type {
    NSInteger count;
    switch (type) {
        case NotificationTypeAll: {
                count = [self.dataManager loadMoreAllNotifications];
            }
            break;
        case NotificationTypeAnnouncement: {
                count = [self.dataManager loadMoreSystemAnnouncements];
            }
            break;
        case NotificationTypeRequirement: {
                count = [self.dataManager loadMoreRequirmentNotifications];
            }
            break;
        case NotificationTypeWorksite: {
                count = [self.dataManager loadMoreWorksiteNotifications];
            }
            break;
            
        default:
            break;
    }
    
    if (count < 20) {
        [self.tableView.footer endRefreshingWithNoMoreData];
    }
    
    [self.tableView reloadData];
}

- (void)resetNoDataTip {
    self.noNotificationLabel.hidden = YES;
    self.noNotificationImage.hidden = YES;
}

- (void)handleNoData:(NSString *)text {
    self.noNotificationLabel.text = text;
    self.noNotificationLabel.hidden = NO;
    self.noNotificationImage.hidden = NO;
}

@end
