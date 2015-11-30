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

static NSString *MessageCellIdentifier = @"MessageCell";

static float kKeyboardHeight = 480;

@interface LeaveMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopToSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeight;

@property (strong, nonatomic) Plan *plan;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;

@end

@implementation LeaveMessageViewController

#pragma mark - init method
- (id)initWithPlan:(Plan *)plan {
    if (self = [super init]) {
        _plan = plan;
        _requirementDataManager = [[RequirementDataManager alloc] init];
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
    [self.tvMessage setBorder:1 andColor:kFinishedColor.CGColor];
    [self.tvMessage setCornerRadius:5];
    [self.footerView setBorder:1 andColor:kUntriggeredColor.CGColor];
    [self.btnSend setCornerRadius:5];
    
    @weakify(self);
    [[self.btnSend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onSendMessage];
    }];
    
    [[[[self.tvMessage.rac_textSignal
        filterNonSpace:^BOOL{
            return YES;
        }]
        doNext:^(NSString *value) {
            if (value.length > 0) {
                self.btnSend.enabled = YES;
                self.btnSend.alpha = 1.0;
            } else {
                self.btnSend.enabled = NO;
                self.btnSend.alpha = 0.5;
            }
        }]
        length:^NSInteger{
            return 120;
        }]
        subscribeNext:^(NSString *value) {
            @strongify(self);
            self.tvMessage.text = value;
            CGSize size = [self.tvMessage sizeThatFits:CGSizeMake(self.tvMessage.bounds.size.width, CGFLOAT_MAX)];
            self.messageHeight.constant = size.height;
        }];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       @strongify(self);
        [self refreshMessageList];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreMessages];
    }];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
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
- (void)onSendMessage {
    LeaveComment *request = [[LeaveComment alloc] init];
    request.topicid = self.plan._id;
    request.topictype = kTopicTypePlan;
    request.to = self.plan.designerid;
    request.content = self.tvMessage.text;
    
    @weakify(self);
    [API leaveComment:request success:^{
        @strongify(self);
        self.tvMessage.text = @"";
        CGSize size = [self.tvMessage sizeThatFits:CGSizeMake(self.tvMessage.bounds.size.width, CGFLOAT_MAX)];
        self.messageHeight.constant = size.height;
        [self.view endEditing:YES];
        [self refreshMessageList];
    } failure:^{
        
    }];
}

- (void)refreshMessageList {
    GetComments *request = [[GetComments alloc] init];
    request.topicid = self.plan._id;
    request.from = @0;
    request.limit = @10;
    
    @weakify(self);
    [API getComments:request success:^{
        @strongify(self);
        [self.tableView.header endRefreshing];
        [self.requirementDataManager refreshComments];
        [self.tableView reloadData];
    } failure:^{
        
    }];
}

- (void)loadMoreMessages {
    GetComments *request = [[GetComments alloc] init];
    request.topicid = self.plan._id;
    request.from = @(self.requirementDataManager.comments.count);
    request.limit = @10;
    
    @weakify(self);
    [API getComments:request success:^{
        @strongify(self);
        [self.tableView.footer endRefreshing];
        NSInteger currentCount = self.requirementDataManager.comments.count;
        [self.requirementDataManager loadMoreComments];
        NSInteger totalCount = self.requirementDataManager.comments.count;
        
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:totalCount - currentCount];
        for (int i = currentCount; i < totalCount; i++) {
            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        if (totalCount > currentCount) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
        }
    } failure:^{
        
    }];
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    // get keyboard height
    kKeyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:0.6
                          delay:0 usingSpringWithDamping:1
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.view.frame = CGRectMake(self.view.frame.origin.x, -kKeyboardHeight, self.view.frame.size.width, self.view.frame.size.height);;
                            self.tableViewTopToSuperView.constant = 64 + kKeyboardHeight;
                            [self.view layoutIfNeeded];
                        } completion:nil];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.6
                          delay:0 usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);;
                            self.tableViewTopToSuperView.constant = 64;
                            [self.view layoutIfNeeded];
                        } completion:nil];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
