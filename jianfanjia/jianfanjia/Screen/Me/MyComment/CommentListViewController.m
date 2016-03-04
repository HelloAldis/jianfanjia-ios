//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentListDataManager.h"
#import "CommentInfoCell.h"

static NSString *CommentInfoCellIdentifier = @"CommentInfoCell";

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

#pragma mark - UI
- (void)initNav {
    self.title = @"我的评论";
    [self initLeftBackInNav];
}

- (void)initUI {
    self.dataManager = [[CommentListDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerNib:[UINib nibWithNibName:CommentInfoCellIdentifier bundle:nil] forCellReuseIdentifier:CommentInfoCellIdentifier];
    
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CommentInfoCellIdentifier];
    [cell initWithDesigner:nil];
    return cell;
}

#pragma mark - api request
- (void)refresh {
    [self resetNoDataTip];
    [self.tableView.footer resetNoMoreData];
    
//    SearchDesigner *request = [[SearchDesigner alloc] init];
//    request.query = [self getQueryDic];
//    request.from = @0;
//    request.limit = @20;
//    
//    [API searchDesigner:request success:^{
//        [self.tableView.header endRefreshing];
//        NSInteger count = [self.dataManager refresh];
//        
//        if (count == 0) {
//            [self handleNoDesigner];
//        } else if (request.limit.integerValue > count) {
//            [self.tableView.footer noticeNoMoreData];
//        }
//        
//        [self.tableView reloadData];
//    } failure:^{
//        [self.tableView.header endRefreshing];
//    } networkError:^{
//        [self.tableView.header endRefreshing];
//    }];
}

- (void)loadMore {
//    SearchDesigner *request = [[SearchDesigner alloc] init];
//    request.query = [self getQueryDic];
//    request.from = @(self.dataManager.designers.count);
//    request.limit = @20;
//    
//    [API searchDesigner:request success:^{
//        [self.tableView.footer endRefreshing];
//        NSInteger count = [self.dataManager loadMore];
//        if (request.limit.integerValue > count) {
//            [self.tableView.footer noticeNoMoreData];
//        }
//        
//        [self.tableView reloadData];
//    } failure:^{
//        [self.tableView.footer endRefreshing];
//    } networkError:^{
//        [self.tableView.footer endRefreshing];
//    }];
}

- (void)resetNoDataTip {
    self.lblNoData.hidden = YES;
    self.noDataImageView.hidden = YES;
}

- (void)handleNoDesigner {
    self.lblNoData.text = @"没有找到任何匹配的设计师";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_designer"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
