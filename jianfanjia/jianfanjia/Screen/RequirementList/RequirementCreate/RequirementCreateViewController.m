//
//  RequirementCreateViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementCreateViewController.h"
#import "HouseRequirementCreateViewController.h"
#import "BusinessRequirementCreateViewController.h"

@interface RequirementCreateViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIViewController<RequirementCreateProtocol> *currentDisplayController;
@property (strong, nonatomic) HouseRequirementCreateViewController *houseRequirementController;
@property (strong, nonatomic) BusinessRequirementCreateViewController *businessRequirementController;

@property (strong, nonatomic) Requirement *editingRequirement;

@property (strong, nonatomic) UIButton *houseBtn;
@property (strong, nonatomic) UIButton *businessBtn;

@property (strong, nonatomic) RACDisposable *houseDisposable;
@property (strong, nonatomic) RACDisposable *businessDisposable;

@property (assign, nonatomic) BOOL isKeyboardShow;

@end

@implementation RequirementCreateViewController

#pragma mark - init method
- (id)initToCreateRequirement {
    Requirement *newRequirement = [[Requirement alloc] init];
    newRequirement._id = @"";
    return [self initWithRequirement:newRequirement];
}

- (id)initToViewRequirement:(Requirement *)requirement {
    return [self initWithRequirement:requirement];
}

- (id)initWithRequirement:(Requirement *)requirement {
    if (self = [super init]) {
        _editingRequirement = requirement;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Nav
- (void)initNav {
    [self initLeftBackInNav];
    if ([self isCreateRequirement]) {
        [self displayDoneButton];
    } else {
        [StatusBlock matchReqt:self.editingRequirement.status action:[ReqtUnorderDesigner action:^{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
            self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
        }]];
    }
    
    if ([self isCreateRequirement] ) {
        self.houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 37)];
        [_houseBtn setNormTitle:@"家装"];
        [_houseBtn addTarget:self action:@selector(onClickRequirementType:) forControlEvents:UIControlEventTouchUpInside];
        
        self.businessBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_houseBtn.frame), 0, CGRectGetWidth(_houseBtn.frame), CGRectGetHeight(_houseBtn.frame))];
        [_businessBtn setNormTitle:@"商装"];
        [_businessBtn addTarget:self action:@selector(onClickRequirementType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_houseBtn.frame) + CGRectGetWidth(_businessBtn.frame), CGRectGetHeight(_houseBtn.frame))];
        [titleView addSubview:_houseBtn];
        [titleView addSubview:_businessBtn];
        self.navigationItem.titleView = titleView;
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeLeft];
        [self.view addGestureRecognizer:swipeRight];
    } else {
        if ([self.editingRequirement.dec_type isEqualToString:kDecTypeBusiness]) {
            self.title = @"商装";
        } else {
            self.title = @"家装";
        }
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)displayDoneButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - UI
- (void)initUI {
    [self initChildView];
}

#pragma mark - gesture
- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture {
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            if (self.currentDisplayController != self.businessRequirementController) {
                [self onClickRequirementType:self.businessBtn];
            }
            
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            if (self.currentDisplayController != self.houseRequirementController) {
                [self onClickRequirementType:self.houseBtn];
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - user action
- (void)onClickRequirementType:(UIButton *)button {
    if (self.houseBtn == button) {
        if (self.currentDisplayController != self.houseRequirementController) {
            [self highlightButton:self.houseBtn high:YES];
            [self highlightButton:self.businessBtn high:NO];
            [self switchControllerFrom:self.currentDisplayController to:self.houseRequirementController];
        }
    } else if (self.businessBtn == button) {
        if (self.currentDisplayController != self.businessRequirementController) {
            [self highlightButton:self.houseBtn high:NO];
            [self highlightButton:self.businessBtn high:YES];
            [self switchControllerFrom:self.currentDisplayController to:self.businessRequirementController];
        }
    }
}

- (void)onClickEdit {
    [self displayDoneButton];
    [self.currentDisplayController triggerEditEvent];
}

- (void)onClickDone {
    [self.currentDisplayController triggerDoneEvent];
}

- (BOOL)hasDataChanged {
    if ([self.houseRequirementController hasDataChanged]
        || [self.businessRequirementController hasDataChanged]) {
        return YES;
    }
    
    return NO;
}

- (void)onClickBack {
    [self.view endEditing:YES];
    if ([self hasDataChanged]) {
        [MessageAlertViewController presentAlert:@"提醒" msg:@"您有未保存的内容，您确定要退出吗？" second:nil reject:nil agree:^{
            [super onClickBack];
        }];
        
        return;
    }
    
    [super onClickBack];
}

#pragma mark - child controller 
- (void)initChildView {
    if ([self isCreateRequirement]) {
        self.houseRequirementController = [[HouseRequirementCreateViewController alloc] initToCreateRequirement];
        self.businessRequirementController = [[BusinessRequirementCreateViewController alloc] initToCreateRequirement];
        [self addChildViewController:self.houseRequirementController];
        [self addChildViewController:self.businessRequirementController];
        self.currentDisplayController = self.houseRequirementController;
        [self.containerView addSubview:self.currentDisplayController.view];
        [self highlightButton:self.houseBtn high:YES];
        [self highlightButton:self.businessBtn high:NO];
    } else {
        if ([self.editingRequirement.dec_type isEqualToString:kDecTypeBusiness]) {
            self.businessRequirementController = [[BusinessRequirementCreateViewController alloc] initToViewRequirement:self.editingRequirement];
            [self addChildViewController:self.businessRequirementController];
            self.currentDisplayController = self.businessRequirementController;
            [self.containerView addSubview:self.currentDisplayController.view];
        } else {
            self.houseRequirementController = [[HouseRequirementCreateViewController alloc] initToViewRequirement:self.editingRequirement];
            [self addChildViewController:self.houseRequirementController];
            self.currentDisplayController = self.houseRequirementController;
            [self.containerView addSubview:self.currentDisplayController.view];
        }
    }
    self.currentDisplayController.view.frame = self.containerView.bounds;
}

- (void)switchControllerFrom:(UIViewController<RequirementCreateProtocol> *)fromViewController to:(UIViewController<RequirementCreateProtocol> *)toViewController {
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionTransitionNone
    animations:^{
        toViewController.view.frame = self.containerView.bounds;
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentDisplayController = toViewController;
            [toViewController didMoveToParentViewController:self];
        }
    }];
}

#pragma mark - util
- (BOOL)isCreateRequirement {
    return [@"" isEqualToString:self.editingRequirement._id];
}

- (void)highlightButton:(UIButton *)button high:(BOOL)high {
    if (high) {
        [button setNormColor:kThemeTextColor];
        [button setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightBold]];
    } else {
        [button setNormColor:kUntriggeredColor];
        [button setFont:[UIFont systemFontOfSize:17]];
    }
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (!self.isKeyboardShow && keyboardHeight > 0) {
        self.isKeyboardShow = YES;
        [self.currentDisplayController keyboardShow:keyboardHeight];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    [self.view endEditing:YES];
    
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (self.isKeyboardShow) {
        self.isKeyboardShow = NO;
        [self.currentDisplayController keyboardHide:keyboardHeight];
    }
}

@end
