//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiaryMessageTableCell.h"
#import "DiaryMessageCell.h"
#import "CommentCountTipSection.h"

static NSString *DiaryMessageCellIdentifier = @"DiaryMessageCell";

@interface DiaryMessageTableCell ()
@property (strong, nonatomic) Diary *diary;
@property (weak, nonatomic) UITableView *superTableView;
@property (assign, nonatomic) CGSize diarySize;
@property (assign, nonatomic) CGFloat preY;

@end

@implementation DiaryMessageTableCell

- (void)awakeFromNib {
    self.dataManager = [[DiaryDetailDataManager alloc] init];
//    self.tableView.isSendEventToNextRespnder = YES;
    self.tableView.delaysContentTouches = NO;
    self.tableView.canCancelContentTouches = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.bounces = NO;
//    self.tableView.alwaysBounceVertical = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerNib:[UINib nibWithNibName:DiaryMessageCellIdentifier bundle:nil] forCellReuseIdentifier:DiaryMessageCellIdentifier];
    
    @weakify(self);
    self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreMessages];
    }];
}

- (void)initWithDiary:(Diary *)diary superTableView:(UITableView *)superTableView diarySize:(CGSize)diarySize {
    self.diary = diary;
    self.superTableView = superTableView;
    self.diarySize = diarySize;
}

#pragma mark - scroll view delegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = self.tableView.contentOffset.y;
    if (y < 0) {
        y = y * 2;
    }
    
    CGFloat supery = self.superTableView.contentOffset.y;
    CGFloat newy = supery + y;
    if (newy >= (self.diarySize.height - kNavWithStatusBarHeight)) {
        [self.superTableView setContentOffset:CGPointMake(0, self.diarySize.height - kNavWithStatusBarHeight)];
    } else {
        [self.superTableView setContentOffset:CGPointMake(0, MAX(-kNavWithStatusBarHeight, newy))];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat sectionHeight =  self.dataManager.comments.count == 0 ? kCommentCountTipSectionHeight : 6.0;
    return sectionHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CommentCountTipSection *view = [CommentCountTipSection commentCountTipSection];
    view.lblTitle.text = self.dataManager.comments.count == 0 ? @"当前还没有任何评论" : @"";
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiaryMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiaryMessageCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithComment:self.dataManager.comments[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment *comment = self.dataManager.comments[indexPath.row];
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(comment, self);
    }
}

#pragma mark - api request
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

@end
