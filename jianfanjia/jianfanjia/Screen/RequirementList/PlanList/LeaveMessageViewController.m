//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "LeaveMessageViewController.h"
#import "ViewControllerContainer.h"
#import "RequirementDataManager.h"
#import "MessageCell.h"

typedef NS_ENUM(NSInteger, CommentType) {
    CommentTypePlan,
    CommentTypeProcess,
};

static NSString *MessageCellIdentifier = @"MessageCell";
static const CGFloat kMinMessageHeight = 50;
static const CGFloat kMaxMessageHeight = 75;

@interface LeaveMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftCharCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeight;

@property (assign, nonatomic) CommentType commentType;
@property (assign, nonatomic) BOOL hasDataUpdate;

@property (strong, nonatomic) Plan *plan;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;

@property (strong, nonatomic) Process *process;
@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSString *item;
@property (copy, nonatomic) void(^RefreshBlock)(void);
@property (assign, nonatomic) NSUInteger maxCount;

@end

@implementation LeaveMessageViewController

#pragma mark - init method
- (id)initWithPlan:(Plan *)plan {
    if (self = [super init]) {
        _commentType = CommentTypePlan;
        _plan = plan;
        _requirementDataManager = [[RequirementDataManager alloc] init];
        _maxCount = 120;
    }
    
    return self;
}

- (id)initWithProcess:(Process *)process section:(NSString *)section item:(NSString *)item block:(void(^)(void))RefreshBlock {
    if (self = [super init]) {
        _commentType = CommentTypeProcess;
        _RefreshBlock = RefreshBlock;
        _process = process;
        _section = section;
        _item = item;
        _requirementDataManager = [[RequirementDataManager alloc] init];
        _maxCount = 120;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:MessageCellIdentifier bundle:nil] forCellReuseIdentifier:MessageCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = true;
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self refreshMessageList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"留言";
}

- (void)initUI {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tvMessage.bgColor = kViewBgColor;
    [self.tvMessage setCornerRadius:5];
    [self.footerView setBorder:1 andColor:kUntriggeredColor.CGColor];
    [self.btnSend setCornerRadius:5];
    self.tvMessage.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 20);
    
    @weakify(self);
    [[self.btnSend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onSendMessage];
    }];

    [[self.tvMessage.rac_textSignal
        length:^NSInteger{
            return self.maxCount;
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
            self.messageHeight.constant = MIN(kMaxMessageHeight, MAX(kMinMessageHeight, self.lblLeftCharCount.bounds.size.height + size.height));
        }];
    
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
       @strongify(self);
        [self refreshMessageList];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreMessages];
    }];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requirementDataManager.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier forIndexPath:indexPath];
    [cell initWithComment:self.requirementDataManager.comments[indexPath.row]];
    
    return cell;
}

#pragma mark - user action
- (void)refreshUI:(NSString *)msg {
    self.lblLeftCharCount.text = [NSString stringWithFormat:@"%@", @(self.maxCount - msg.length)];
    [self enableSendBtn:msg.length > 0];
}

- (void)onClickBack {
    if (self.hasDataUpdate) {
        if (self.RefreshBlock) {
            self.RefreshBlock();
        }
    }
    [super onClickBack];
}

- (void)enableSendBtn:(BOOL)enable {
    [self.btnSend enableBgColor:enable];
}

- (void)onSendMessage {
    [self.view endEditing:YES];
    LeaveComment *request = [[LeaveComment alloc] init];
    
    if (self.commentType == CommentTypePlan) {
        request.topicid = self.plan._id;
        request.topictype = kTopicTypePlan;
        request.to_designerid = self.plan.designerid;
        request.content = self.tvMessage.text;
    } else if (self.commentType == CommentTypeProcess) {
        request.topicid = self.process._id;
        request.topictype = kTopicTypeProcess;
        request.section = self.section;
        request.item = self.item;
        request.to_designerid = self.process.final_designerid;
        request.content = self.tvMessage.text;
    }
    
    @weakify(self);
    [self enableSendBtn:NO];
    [API leaveComment:request success:^{
        @strongify(self);
        self.hasDataUpdate = YES;
        self.tvMessage.text = @"";
        [self refreshUI:@""];
        CGSize size = [self.tvMessage sizeThatFits:CGSizeMake(self.tvMessage.bounds.size.width, CGFLOAT_MAX)];
        self.messageHeight.constant = MIN(kMaxMessageHeight, MAX(kMinMessageHeight, self.lblLeftCharCount.bounds.size.height + size.height));
        [self refreshMessageList];
    } failure:^{
    } networkError:^{
    }];
}

- (void)refreshMessageList {
    GetComments *request = [[GetComments alloc] init];
    
    if (self.commentType == CommentTypePlan) {
        request.topicid = self.plan._id;
    } else if (self.commentType == CommentTypeProcess) {
        request.topicid = self.process._id;
        request.section = self.section;
        request.item = self.item;
    }
    
    request.from = @0;
    request.limit = @10;
    
    [self.tableView.footer resetNoMoreData];
    @weakify(self);
    [API getComments:request success:^{
        @strongify(self);
        [self.tableView.header endRefreshing];
        [self.requirementDataManager refreshComments];
        NSInteger currentCount = self.requirementDataManager.comments.count;
        if (request.limit.integerValue > currentCount) {
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
    
    if (self.commentType == CommentTypePlan) {
        request.topicid = self.plan._id;
    } else if (self.commentType == CommentTypeProcess) {
        request.topicid = self.process._id;
        request.section = self.section;
        request.item = self.item;
    }
    
    request.from = @(self.requirementDataManager.comments.count);
    request.limit = @10;
    
    @weakify(self);
    [API getComments:request success:^{
        @strongify(self);
        [self.tableView.footer endRefreshing];
        NSInteger currentCount = self.requirementDataManager.comments.count;
        [self.requirementDataManager loadMoreComments];
        NSInteger totalCount = self.requirementDataManager.comments.count;
        if (request.limit.integerValue > (totalCount - currentCount)) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyboardHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

@end
