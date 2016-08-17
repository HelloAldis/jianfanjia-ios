//
//  RequestPlanViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequestPlanViewController.h"
#import "ViewControllerContainer.h"
#import "SuccessAlertViewController.h"

@interface RequestPlanViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *reqScrollView;
@property (weak, nonatomic) IBOutlet UITextField *fldNickName;
@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnReq;

@end

@implementation RequestPlanViewController

+ (void)show {
    RequestPlanViewController *v = [[RequestPlanViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:v];
    
    v.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    v.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[ViewControllerContainer navigation] presentViewController:navi animated:YES completion:nil];
}

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
            self.reqScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight + kTabBarHeight, 0);
            self.reqScrollView.contentOffset = CGPointMake(0, keyboardHeight - kTabBarHeight - 55);
        } else {
            self.reqScrollView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
            self.reqScrollView.contentOffset = CGPointMake(0, 0);
        }
    } completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self jfj_unsubscribeKeyboard];
}

#pragma mark - init ui
- (void)initNav {
    self.title = @"免费获取方案";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.leftBarButtonItem.tintColor = kTextColor;
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    @weakify(self);
    [[[self.fldPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.fldPhone.text = x;
    }];
    
    [[RACSignal
      combineLatest:@[self.fldPhone.rac_textSignal, self.fldNickName.rac_textSignal]
      reduce:^(NSString *phone, NSString *nickName) {
          return @([AccountBusiness validatePhone:phone] && ![nickName isEmpty]);
      }] subscribeNext:^(id x) {
          [self.btnReq enableBgColor:[x boolValue]];
      }];
    
    self.reqScrollView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    self.reqScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    [self.btnReq setCornerRadius:5];
    [self.fldNickName setCornerRadius:5];
    [self.fldPhone setCornerRadius:5];
    
    [self setLeftPadding:self.fldNickName withImage:[UIImage imageNamed:@"icon_requirement_nickname"]];
    [self setLeftPadding:self.fldPhone withImage:[UIImage imageNamed:@"icon_requirement_phone"]];
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

#pragma mark - user action
- (void)onClickBack {
    [self.view endEditing:YES];
    
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickRequest:(id)sender {
    AddAngelUser *request = [[AddAngelUser alloc] init];
    request.name = self.fldNickName.text;
    request.phone = self.fldPhone.text;
    request.district = kAngelUserDistrictRequirement;
    
    [HUDUtil showWait];
    [API addAngelUser:request success:^{
        [self onClickBack];
        self.fldPhone.text = nil;
        self.fldNickName.text = nil;
        [self.btnReq enableBgColor:NO];
        [SuccessAlertViewController presentAlert:@"申请成功" msg:@"我们的工作人员将在24小时之内与您联系，请保持电话畅通" ok:nil];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
