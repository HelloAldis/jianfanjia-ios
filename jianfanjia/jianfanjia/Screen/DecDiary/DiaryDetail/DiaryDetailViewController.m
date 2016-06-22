//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiaryDetailViewController.h"
#import "DecDiaryStatusAllCell.h"
#import "DiaryMessageCell.h"
#import "CommentCountTipSection.h"
#import "DiaryDetailDataManager.h"
#import "ViewControllerContainer.h"

static NSString *DecDiaryStatusCellIdentifier = @"DecDiaryStatusAllCell";
static NSString *DiaryMessageCellIdentifier = @"DiaryMessageCell";

static const CGFloat kMinMessageHeight = 40;
static const CGFloat kMaxMessageHeight = 80;
static NSString *kDeafultTVHolder = @"添加评论";

@interface DiaryDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftCharCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeight;
@property (assign, nonatomic) NSUInteger maxCount;

@property (strong, nonatomic) DiaryDetailDataManager *dataManager;
@property (strong, nonatomic) Diary *diary;
@property (strong, nonatomic) User *curToUser;
@property (assign, nonatomic) BOOL showComment;
@property (assign, nonatomic) BOOL wasFirstLoad;

@end

@implementation DiaryDetailViewController

- (instancetype)initWithDiary:(Diary *)diary showComment:(BOOL)showComment toUser:(User *)toUser {
    if (self = [super init]) {
        _diary = diary;
        _showComment = showComment;
        _curToUser = [[User alloc] init];
        if (toUser) {
            [_curToUser merge:toUser];
        } else {
            _curToUser._id = _diary.authorid;
        }
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
//    [self initContentInset];
    
    @weakify(self);
    [self jfj_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, BOOL isShowing) {
        @strongify(self);
        CGFloat keyboardHeight = keyboardRect.size.height;
        self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - (isShowing ? keyboardHeight : 0));
    } completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self jfj_unsubscribeKeyboard];
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
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerNib:[UINib nibWithNibName:DecDiaryStatusCellIdentifier bundle:nil] forCellReuseIdentifier:DecDiaryStatusCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DiaryMessageCellIdentifier bundle:nil] forCellReuseIdentifier:DiaryMessageCellIdentifier];
    
    self.tvMessage.bgColor = kViewBgColor;
    [self.tvMessage setCornerRadius:5];
    [self.footerView setBorder:0.5 andColor:[UIColor colorWithR:0xE8 g:0xE9 b:0xEA].CGColor];
    [self.btnSend setCornerRadius:5];
    self.tvMessage.textContainerInset = UIEdgeInsetsMake(10, 5, 8, 5);
    self.tvMessage.alwaysBounceVertical = YES;
    
    @weakify(self);
    [[self.btnSend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onSendMessage];
    }];
    
    [[self.tvMessage.rac_textSignal
      length:^NSInteger{
          return NSIntegerMax;
      }]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         if ([value trim].length == 0) {
             self.tvMessage.text = [value trim];
             [self refreshUI:[value trim]];
             return;
         }
         
         self.tvMessage.text = value;
         [self refreshUI:value];
         CGSize size = [self.tvMessage sizeThatFits:CGSizeMake(self.tvMessage.bounds.size.width, CGFLOAT_MAX)];
         self.messageHeight.constant = MIN(kMaxMessageHeight, MAX(kMinMessageHeight, size.height));
     }];
    
    [RACObserve(self.curToUser, username) subscribeNext:^(NSString *username) {
        @strongify(self);
        if (username.length == 0) {
            self.tvMessage.placeholder = kDeafultTVHolder;
        } else {
            self.tvMessage.placeholder = [NSString stringWithFormat:@"%@ %@ %@", kDiaryMessagePrefix, username, kDiaryMessageSubfix];
        }
        
    }];
    
    self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreMessages];
    }];
    
    [self refreshDiary:!self.showComment];
    [self refreshMessageList:self.showComment];
}

- (void)initContentInset {
    if (self.showComment && !self.wasFirstLoad) {
        self.wasFirstLoad = YES;
        DecDiaryStatusAllCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier];
        [cell initWithDiary:self.diary diarys:nil tableView:nil];
        CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kScreenHeight, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.contentOffset = CGPointMake(0, size.height - kNavWithStatusBarHeight + 1.0);
        });
    }
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    
    return self.dataManager.comments.count == 0 ? kCommentCountTipSectionHeight : 6.0;
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
        DecDiaryStatusAllCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithDiary:self.diary diarys:self.dataManager.diarys tableView:self.tableView];
        
        cell.deleteDoneBlock = ^{
            [self onClickBack];
        };
        
        cell.clickCommentBlock = ^{
            [self.tvMessage becomeFirstResponder];
        };
        
        return cell;
    }
    
    DiaryMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiaryMessageCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithComment:self.dataManager.comments[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tvMessage.text.length == 0) {
        if (indexPath.section == 0) {
            [self updateAuthorIdToUserId];
        } else {
            Comment *comment = self.dataManager.comments[indexPath.row];
            if ([DiaryBusiness isOwnComment:comment]) {
                [self updateAuthorIdToUserId];
            } else {
                [self updateToUserId:comment.user._id name:comment.user.username];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showComment && !self.wasFirstLoad && indexPath.section == 0) {
        self.wasFirstLoad = YES;
        CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kScreenHeight, 0);
            self.tableView.contentOffset = CGPointMake(0, CGRectGetMaxY(cellRect) - kNavWithStatusBarHeight + 2.0);
        });
    }
}

#pragma mark - api request
- (void)refreshDiary:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    
    GetDiaryDetail *request = [[GetDiaryDetail alloc] init];
    request.diaryid = self.diary._id;
    [API getDiaryDetail:request success:^{
        [HUDUtil hideWait];
        [self.dataManager refreshDiary];
        if ([self.diary.is_deleted boolValue]) {
            [HUDUtil showText:@"日记已被删除" delayShow:0.3];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self onClickBack];
            });
        } else {
            [self.tableView reloadData];
        }
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
- (void)refreshUI:(NSString *)msg {
    self.lblLeftCharCount.text = [NSString stringWithFormat:@"%@", @(self.maxCount - msg.length)];
    [self enableSendBtn:msg.length > 0];
}

- (void)enableSendBtn:(BOOL)enable {
    [self.btnSend enableBgColor:enable];
}

- (void)onSendMessage {
    [self.view endEditing:YES];
    LeaveComment *request = [[LeaveComment alloc] init];
    request.topicid = self.diary._id;
    request.topictype = kTopicTypeDiary;
    request.to_userid = self.curToUser._id;
    
    if (![self.tvMessage.placeholder isEqualToString:kDeafultTVHolder]) {
        request.content = [NSString stringWithFormat:@"%@%@", self.tvMessage.placeholder, self.tvMessage.text];
    } else {
        request.content = self.tvMessage.text;
    }

    @weakify(self);
    [self enableSendBtn:NO];
    [API leaveComment:request success:^{
        @strongify(self);
        self.tvMessage.text = @"";
        [self refreshUI:@""];
        CGSize size = [self.tvMessage sizeThatFits:CGSizeMake(self.tvMessage.bounds.size.width, CGFLOAT_MAX)];
        self.messageHeight.constant = MIN(kMaxMessageHeight, MAX(kMinMessageHeight, size.height));
        [self updateAuthorIdToUserId];
        [self refreshDiary:NO];
        [self refreshMessageList:NO];
    } failure:^{
    } networkError:^{
    }];
}

#pragma mark - other
- (void)updateAuthorIdToUserId {
    [self updateToUserId:self.diary.authorid name:@""];
}

- (void)updateToUserId:(NSString *)toId name:(NSString *)username {
    self.curToUser._id = toId;
    self.curToUser.username = username;
}

@end
