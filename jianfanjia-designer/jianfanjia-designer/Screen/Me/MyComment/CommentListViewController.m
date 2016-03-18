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

static NSString *PlanCommentInfoCellIdentifier = @"PlanCommentInfoCell";
static NSString *DecCommentInfoCellIdentifier = @"DecCommentInfoCell";

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"我的留言";
    [self initLeftBackInNav];
}

- (void)initUI {
    self.dataManager = [[CommentListDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    [self.tableView registerNib:[UINib nibWithNibName:PlanCommentInfoCellIdentifier bundle:nil] forCellReuseIdentifier:PlanCommentInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DecCommentInfoCellIdentifier bundle:nil] forCellReuseIdentifier:DecCommentInfoCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    
    [self refresh];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DesignerNotification *notification = self.dataManager.comments[indexPath.row];
    
    if ([notification.message_type isEqualToString:kDesignerPNFromPlanComment]) {
        PlanCommentInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PlanCommentInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithNotification:notification];
        return cell;
    } else if ([notification.message_type isEqualToString:kDesignerPNFromDecItemComment
                ]) {
        DecCommentInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecCommentInfoCellIdentifier];
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
    
    SearchDesignerComment *request = [[SearchDesignerComment alloc] init];
    request.from = @0;
    request.limit = @20;
    
    [API searchDesignerComment:request success:^{
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
    SearchDesignerComment *request = [[SearchDesignerComment alloc] init];
    request.from = @(self.dataManager.comments.count);
    request.limit = @20;
    
    [API searchDesignerComment:request success:^{
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
    self.lblNoData.text = @"您还没有收到留言";
    self.noDataImageView.image = [UIImage imageNamed:@"img_no_leave_msg"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
