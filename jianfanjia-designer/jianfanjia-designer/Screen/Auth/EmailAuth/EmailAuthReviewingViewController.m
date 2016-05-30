//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "EmailAuthReviewingViewController.h"
#import "DesignerAuthViewController.h"
#import "ViewControllerContainer.h"

@interface EmailAuthReviewingViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UITextField *fldEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblText1;
@property (weak, nonatomic) IBOutlet UILabel *lblText2;
@property (weak, nonatomic) IBOutlet UILabel *lblText3;

@end

@implementation EmailAuthReviewingViewController

- (instancetype)initWithDesigner:(Designer *)designer {
    if (self = [super init]) {
        _designer = designer;
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
    [self initData];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"邮箱认证";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    [self.iconView setCornerRadius:self.iconView.frame.size.width / 2];
    [self.fldEmail setCornerRadius:5];
    [self setLeftPadding:self.fldEmail withImage:[UIImage imageNamed:@"icon_email"]];
    [self setRightPadding:self.fldEmail];
    
    self.lblText1.text = @"我们已向您的邮箱发送了一份验证邮件\n请前往查收并完成验证";
    self.lblText3.attributedText = [@"是不是邮箱输错了？请点击 修改邮箱" attrSubStr:@"修改邮箱" font:[UIFont systemFontOfSize:15] color:kThemeColor];
    [self.lblText2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickResend)]];
    [self.lblText3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickModify)]];
}

- (void)initData {
    self.fldEmail.text = self.designer.email;
}

- (void)setLeftPadding:(UITextField *)textField withImage:(UIImage *)image {
    CGRect frame = textField.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = 60;
    UIImageView *leftview = [[UIImageView alloc] initWithFrame:frame];
    leftview.image = image;
    leftview.contentMode = UIViewContentModeCenter;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

- (void)setRightPadding:(UITextField *)textField {
    CGRect frame = textField.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = 70;
    UIView *rightview = [[UIView alloc] initWithFrame:frame];
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = rightview;
}

#pragma mark - user action
- (void)onClickResend {
    [HUDUtil showWait];
    DesignerSendEmailVerify *request = [[DesignerSendEmailVerify alloc] init];
    [API designerSendEmailVerify:request success:^{
        [HUDUtil hideWait];
        [HUDUtil showSuccessText:@"重新发送成功"];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

- (void)onClickModify {
    [ViewControllerContainer showEmailAuthRequest:self.designer];
}

- (void)onClickDone {
    [self navigateToOriginController];
}

- (void)navigateToOriginController {
    UIViewController *popTo = nil;
    for (UIViewController *controller in [self.navigationController.viewControllers reverseObjectEnumerator]) {
        if ([controller isKindOfClass:[DesignerAuthViewController class]]) {
            popTo = controller;
            break;
        }
    }
    
    [self.navigationController popToViewController:popTo animated:YES];
}

@end
