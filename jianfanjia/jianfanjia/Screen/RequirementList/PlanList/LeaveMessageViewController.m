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

@interface LeaveMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (strong, nonatomic) Plan *plan;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;

@end

@implementation LeaveMessageViewController

#pragma mark - init method
- (id)initWithPlan:(Plan *)plan withOrder:(NSInteger)order forRequirement:(Requirement *)requirement {
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
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"留言";
}

- (void)initUI {
    [self.tvMessage setBorder:1 andColor:[UIColor colorWithR:0xFE g:0x70 b:0x04].CGColor];
    [self.tvMessage setCornerRadius:5];
    [self.btnSend setCornerRadius:5];
    
    @weakify(self);
    [[self.btnSend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onSendMessage];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - user action
- (void)onSendMessage {
    [ViewControllerContainer showPlanPriceDetail:self.plan];
}

- (void)refreshMessageList {
    GetComments *request = [[GetComments alloc] init];
    request.topicid = self.plan._id;
    request.from = @0;
    request.limit = @10;
    
    [API getComments:request success:^{
        [self.requirementDataManager refreshComments];
        [self.tableView reloadData];
    } failure:^{
        
    }];
}

- (void)loadMore {
    
}

@end
