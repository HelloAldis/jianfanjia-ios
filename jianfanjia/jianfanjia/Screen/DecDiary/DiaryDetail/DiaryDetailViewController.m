//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiaryDetailViewController.h"
#import "DecDiaryStatusCell.h"
#import "DiaryMessageCell.h"
#import "CommentCountTipSection.h"
#import "DiaryDetailDataManager.h"
#import "ViewControllerContainer.h"

static NSString *DecDiaryStatusCellIdentifier = @"DecDiaryStatusCell";
static NSString *DiaryMessageCellIdentifier = @"DiaryMessageCell";

@interface DiaryDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DiaryDetailDataManager *dataManager;
@property (strong, nonatomic) Diary *diary;
@property (assign, nonatomic) BOOL showComment;

@end

@implementation DiaryDetailViewController

- (instancetype)initWithDiary:(Diary *)diary showComment:(BOOL)showComment {
    if (self = [super init]) {
        _diary = diary;
        _showComment = showComment;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"日记正文";
}

- (void)initUI {
    self.dataManager = [[DiaryDetailDataManager alloc] init];
    [self.dataManager initDiary:self.diary];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerNib:[UINib nibWithNibName:DecDiaryStatusCellIdentifier bundle:nil] forCellReuseIdentifier:DecDiaryStatusCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DiaryMessageCellIdentifier bundle:nil] forCellReuseIdentifier:DiaryMessageCellIdentifier];
    
    @weakify(self);
    self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreMessages];
    }];
    
    [self refreshDiary:!self.showComment];
    [self refreshMessageList:self.showComment];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    
    return self.dataManager.comments.count == 0 ? kCommentCountTipSectionHeight : 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    CommentCountTipSection *view = [CommentCountTipSection commentCountTipSection];
    view.lblTitle.text = self.dataManager.comments.count == 0 ? @"当前还没有任何评论" : @"";
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataManager.diarys.count;
    }
    
    return self.dataManager.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DecDiaryStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithDiary:self.diary diarys:self.dataManager.diarys tableView:self.tableView truncate:NO];
        return cell;
    }
    
    DiaryMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiaryMessageCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithComment:self.dataManager.comments[indexPath.row]];
    return cell;
}

#pragma mark - api request
- (void)refreshDiary:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    
    GetDiaryDetail *request = [[GetDiaryDetail alloc] init];
    request.diaryid = self.diary._id;
    [API getDiaryDetail:request success:^{
        [self.dataManager refreshDiary];
        [self.tableView reloadData];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)refreshMessageList:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    
    GetComments *request = [[GetComments alloc] init];
    request.topicid = self.diary._id;
    request.from = @0;
    request.limit = @50;
    
    [self.tableView.footer resetNoMoreData];
    @weakify(self);
    [API getComments:request success:^{
        @strongify(self);
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager refreshComment];
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

- (void)loadMoreMessages {
    GetComments *request = [[GetComments alloc] init];
    request.topicid = self.diary._id;
    request.from = @(self.dataManager.comments.count);
    request.limit = @50;
    
    @weakify(self);
    [API getComments:request success:^{
        @strongify(self);
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.dataManager loadMoreComment];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - user action


@end
