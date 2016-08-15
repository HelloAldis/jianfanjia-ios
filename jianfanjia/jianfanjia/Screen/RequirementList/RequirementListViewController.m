//
//  RequirementListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementListViewController.h"
#import "RequirementDataManager.h"
#import "RequirementCell.h"
#import "ViewControllerContainer.h"

static NSString *RequirementCellIdentifier = @"RequirementCell";

@interface RequirementListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *reqScrollView;
@property (weak, nonatomic) IBOutlet UITextField *fldNickName;
@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnReq;

@property (strong, nonatomic) RequirementDataManager *dataManager;

@end

@implementation RequirementListViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    @weakify(self);
    [self jfj_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, BOOL isShowing) {
        @strongify(self);
        if (isShowing) {
            CGFloat keyboardHeight = keyboardRect.size.height;
            self.reqScrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, keyboardHeight+kTabBarHeight, 0);
            self.reqScrollView.contentOffset = CGPointMake(0, keyboardHeight-kNavWithStatusBarHeight-40);
        } else {
            self.reqScrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
        }
    } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshRequirements:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self jfj_unsubscribeKeyboard];
}

#pragma mark - init ui
- (void)initNav {
    self.title = @"我要装修";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCustomerService)];
    self.navigationItem.rightBarButtonItem.tintColor = kTextColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataManager = [[RequirementDataManager alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 55, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    [self.tableView registerNib:[UINib nibWithNibName:RequirementCellIdentifier bundle:nil] forCellReuseIdentifier:RequirementCellIdentifier];
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshRequirements:NO];
    }];
    
    [[[self.fldPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.fldPhone.text = x;
    }];
    
    self.reqScrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    self.reqScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    [self.btnReq setCornerRadius:5];
    [self.fldNickName setCornerRadius:5];
    [self.fldPhone setCornerRadius:5];
    
    [self setLeftPadding:self.fldNickName withImage:[UIImage imageNamed:@"icon_requirement_nickname"]];
    [self setLeftPadding:self.fldPhone withImage:[UIImage imageNamed:@"icon_requirement_phone"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRequirementCreate) name:kRequirementCreateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogout) name:kLogoutNotification object:nil];
}

- (void)setLeftPadding:(UITextField *)textField withImage:(UIImage *)image {
    CGRect frame = textField.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = 60;
    UIView *leftview = [[UIView alloc] init];
    leftview.frame = frame;
    
    frame.size.width = frame.size.height;
    UIView *leftImgview = [[UIView alloc] init];
    leftImgview.frame = frame;
    leftImgview.backgroundColor = [UIColor colorWithR:0xE7 g:0xEC b:0xEF];
    
    frame.size.width = 20;
    frame.size.height = frame.size.width;
    frame.origin.x = (leftImgview.frame.size.width - frame.size.width) / 2.0;
    frame.origin.y = (leftImgview.frame.size.height - frame.size.height) / 2.0;
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:frame];
    leftImg.image = image;
    leftImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [leftImgview addSubview:leftImg];
    [leftview addSubview:leftImgview];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

- (void)showRequirementList:(BOOL)show {
    if (show) {
        self.reqScrollView.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        self.reqScrollView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

- (void)handleRequirementCreate {
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}

- (void)handleLogout {
    self.dataManager.requirements = nil;
    [self.tableView reloadData];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataManager.requirements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:RequirementCellIdentifier forIndexPath:indexPath];
    [cell initWithRequirement:self.dataManager.requirements[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Requirement *requirement = self.dataManager.requirements[indexPath.row];
    
    __block NSInteger height = 286;
    if ([RequirementBusiness isDesignRequirement:requirement.work_type]) {
        [self.dataManager refreshOrderedDesigners:requirement];
        NSArray *orderedDesigners = self.dataManager.orderedDesigners;
        NSString *status = requirement.status;
        [StatusBlock matchReqt:status actions:
         @[[ReqtUnorderDesigner action:^{
                height = 286;
            }],
           [ReqtConfiguredAgreement action:^{
                height = 286;
            }],
           [ReqtPlanWasChoosed action:^{
                height = 286;
            }],
           [ElseStatus action:^{
                static NSArray *actionStatus;
                actionStatus = @[kPlanStatusDesignerRespondedWithoutMeasureHouse, kPlanStatusDesignerSubmittedPlan];
                
                __block NSInteger actionIndex = -1;
                [orderedDesigners enumerateObjectsUsingBlock:^(Designer *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *status = obj.plan.status;
                    if ([actionStatus containsObject:status]) {
                        actionIndex = idx;
                        *stop = YES;
                    }
                }];
                
                if (actionIndex != -1) {
                    height = 286;
                } else {
                    height = 239;
                }
            }],
           ]];
    }
    
    return height;
}

#pragma mark - send request
- (void)refreshRequirements:(BOOL)showPlsWait {
    if ([[LoginEngine shared] isLogin]) {
        if (showPlsWait) {
            [HUDUtil showWait];
        }
        
        GetUserRequirement *getRequirements = [[GetUserRequirement alloc] init];
        
        [API getUserRequirement:getRequirements success:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
            [self.dataManager refreshRequirementList];
            [self showRequirementList:self.dataManager.requirements.count > 0];
            
            [self.tableView reloadData];
        } failure:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
        } networkError:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
        }];
    } else {
        [self showRequirementList:NO];
    }
}

#pragma mark - user action
- (void)onClickCustomerService {
    [PhoneUtil call:@"咨询热线" phone:kConsultPhone];
}

- (IBAction)onClickRequest:(id)sender {
    
}

@end
