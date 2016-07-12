//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentListDataManager.h"
#import "PlanCommentInfoCell.h"
#import "DecCommentInfoCell.h"
#import "DiaryCommentInfoCell.h"

static NSString *PlanCommentInfoCellIdentifier = @"PlanCommentInfoCell";
static NSString *DecCommentInfoCellIdentifier = @"DecCommentInfoCell";
static NSString *DiaryCommentInfoCellIdentifier = @"DiaryCommentInfoCell";

@interface CommentListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;

@property (strong, nonatomic) CommentListDataManager *dataManager;

@end

@implementation CommentListViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kShowNotificationDetail object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NotificationDataManager shared] refreshUnreadCount];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"我的评论";
}

- (void)initUI {
    self.dataManager = [[CommentListDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 220;
    [self.tableView registerNib:[UINib nibWithNibName:PlanCommentInfoCellIdentifier bundle:nil] forCellReuseIdentifier:PlanCommentInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DecCommentInfoCellIdentifier bundle:nil] forCellReuseIdentifier:DecCommentInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DiaryCommentInfoCellIdentifier bundle:nil] forCellReuseIdentifier:DiaryCommentInfoCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserNotification *notification = self.dataManager.comments[indexPath.row];
    
    if ([notification.message_type isEqualToString:kUserPNFromPlanComment]) {
        PlanCommentInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PlanCommentInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithNotification:notification];
        return cell;
    } else if ([notification.message_type isEqualToString:kUserPNFromDecItemComment
                ]) {
        DecCommentInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecCommentInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithNotification:notification];
        return cell;
    } else if ([notification.message_type isEqualToString:kUserPNFromDiaryComment
                ]) {
        DiaryCommentInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiaryCommentInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithNotification:notification];
        return cell;
    }

    return nil;
}

#pragma mark - api request
- (void)refresh {
    [self resetNoDataTip];
    [self.tableView.footer resetNoMoreData];
    
    SearchUserComment *request = [[SearchUserComment alloc] init];
    request.from = @0;
    request.limit = @20;
    
    [API searchUserComment:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager refresh];
        if (count == 0) {
            [self handleNoDesigner];
        } else if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMore {
    SearchUserComment *request = [[SearchUserComment alloc] init];
    request.from = @(self.dataManager.comments.count);
    request.limit = @20;
    
    [API searchUserComment:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager loadMore];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }

        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)resetNoDataTip {
    self.lblNoData.hidden = YES;
    self.noDataImageView.hidden = YES;
}

- (void)handleNoDesigner {
    self.lblNoData.text = @"您还没有收到评论";
    self.noDataImageView.image = [UIImage imageNamed:@"img_no_leave_msg"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
