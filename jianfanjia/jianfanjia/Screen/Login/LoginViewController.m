//
//  LoginViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/5.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewControllerContainer.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *loginAngleUp;
@property (weak, nonatomic) IBOutlet UIImageView *signupAngleUp;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIImageView *iconWechatLogin;
@property (weak, nonatomic) IBOutlet UITextField *fldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnTitleLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnTitleSignup;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPwd;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UIView *viewSignup;
@property (weak, nonatomic) IBOutlet UIView *viewThirdParty;

@property (weak, nonatomic) IBOutlet UITextField *fldSignupPhone;
@property (weak, nonatomic) IBOutlet UITextField *fldSignupPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginPhoneFldTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signupPhoneFldTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginPwdFldTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signupPwdFldTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextTopConstraint;

@property (assign, nonatomic) BOOL isShowingLogin;

@end

@implementation LoginViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.viewThirdParty.hidden = ![JYZSocialSnsConfigCenter isWXAppInstalled];
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)onClickBack {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [[LoginEngine shared] executeLoginBlock:NO];
    }];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.navigationController.navigationBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapNavBarGesture:)]];
    
    @weakify(self);
    [RACObserve(self.btnLogin, enabled) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        if (newValue.boolValue) {
            [self.btnLogin setBackgroundColor:kFinishedColor];
        } else {
            [self.btnLogin setBackgroundColor:kUntriggeredColor];
        }
    }];
    
    [RACObserve(self.btnNext, enabled) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        if (newValue.boolValue) {
            [self.btnNext setBackgroundColor:kFinishedColor];
        } else {
            [self.btnNext setBackgroundColor:kUntriggeredColor];
        }
    }];
    
    [[[self.fldPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }] subscribeNext:^(id x) {
        self.fldPhone.text = x;
    }];
    
    [[[self.fldSignupPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }] subscribeNext:^(id x) {
        self.fldSignupPhone.text = x;
    }];;
    
    [[[self.fldPassword.rac_textSignal filterNonSpace:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPasswordLength;
    }] subscribeNext:^(id x) {
        self.fldPassword.text = x;
    }];
    
    [[[self.fldSignupPassword.rac_textSignal filterNonSpace:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPasswordLength;
    }] subscribeNext:^(id x) {
        self.fldSignupPassword.text = x;
    }];
    
    RAC(self.btnLogin, enabled) = [RACSignal
                                   combineLatest:@[self.fldPhone.rac_textSignal, self.fldPassword.rac_textSignal]
                                   reduce:^(NSString *phone, NSString *password) {
                                       return @([AccountBusiness validateLogin:phone pass:password]);
                                   }];
    
    RAC(self.btnNext, enabled) = [RACSignal
                                  combineLatest:@[self.fldSignupPhone.rac_textSignal, self.fldSignupPassword.rac_textSignal]
                                  reduce:^(NSString *phone, NSString *password) {
                                      return @([AccountBusiness validatePhone:phone] && [AccountBusiness validatePass:password]);
                                  }];
    
    [self.btnLogin setCornerRadius:5];
    [self.btnNext setCornerRadius:5];
    [self.fldPhone setCornerRadius:5];
    [self.fldPassword setCornerRadius:5];
    [self.fldSignupPhone setCornerRadius:5];
    [self.fldSignupPassword setCornerRadius:5];
    
    self.btnLogin.enabled = NO;
    self.btnNext.enabled = NO;
    self.loginAngleUp.hidden = !self.isShowingLogin;
    self.signupAngleUp.hidden = self.isShowingLogin;
    
    [self setLeftPadding:self.fldPhone withImage:[UIImage imageNamed:@"icon_account_phone"]];
    [self setLeftPadding:self.fldPassword withImage:[UIImage imageNamed:@"icon_account_pwd"]];
    [self setLeftPadding:self.fldSignupPhone withImage:[UIImage imageNamed:@"icon_account_phone"]];
    [self setLeftPadding:self.fldSignupPassword withImage:[UIImage imageNamed:@"icon_account_pwd"]];
    
    if (kIs35inchScreen || kIs40inchScreen) {
        self.loginPhoneFldTopConstraint.constant = 15;
        self.loginPwdFldTopConstraint.constant = 15;
        self.loginTopConstraint.constant = 25;
        self.signupPhoneFldTopConstraint.constant = 15;
        self.signupPwdFldTopConstraint.constant = 15;
        self.nextTopConstraint.constant = 25;
    }
    
    if (self.showSignup) {
        self.isShowingLogin = YES;
        [self showSignupView:NO];
    } else {
        self.isShowingLogin = NO;
        [self showLoginView:NO];
    }
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

#pragma mark - gesture
- (IBAction)swipeRight:(id)sender {
    [self.view endEditing:YES];
    [self showLoginView:YES];
}

- (IBAction)swipeLeft:(id)sender {
    [self.view endEditing:YES];
    [self showSignupView:YES];
}

- (void)showLoginView:(BOOL)animated {
    if (!self.isShowingLogin) {
        self.isShowingLogin = YES;
        
        CGRect frame = self.viewLogin.frame;
        frame.origin.x = -kScreenWidth;
        self.viewLogin.frame = frame;
        self.viewLogin.alpha = 1;
        self.viewSignup.alpha = 0;
        
        [UIView animateWithDuration:animated ? 0.4 : 0.0 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.viewLogin.frame;
            frame.origin.x = 0;
            self.viewLogin.frame = frame;
            
            frame = self.viewSignup.frame;
            frame.origin.x = kScreenWidth;
            self.viewSignup.frame = frame;
            
            self.loginAngleUp.hidden = NO;
            self.signupAngleUp.hidden = YES;
            
            [self.btnTitleLogin setEnableAlpha];
            [self.btnTitleSignup setDisableAlpha];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showSignupView:(BOOL)animated {
    if (self.isShowingLogin) {
        self.isShowingLogin = NO;
        
        CGRect frame = self.viewSignup.frame;
        frame.origin.x = kScreenWidth;
        self.viewSignup.frame = frame;
        self.viewSignup.alpha = 1;
        self.viewLogin.alpha = 0;
        
        [UIView animateWithDuration:animated ? 0.4 : 0.0 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.viewSignup.frame;
            frame.origin.x = 0;
            self.viewSignup.frame = frame;
            
            frame = self.viewLogin.frame;
            frame.origin.x = -kScreenWidth;
            self.viewLogin.frame = frame;
            
            self.loginAngleUp.hidden = YES;
            self.signupAngleUp.hidden = NO;
            
            [self.btnTitleSignup setEnableAlpha];
            [self.btnTitleLogin setDisableAlpha];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)onTapNavBarGesture:(UITapGestureRecognizer *)g {
    CGPoint point = [g locationInView:self.headerView];
    id view = [self.headerView hitTest:point withEvent:nil];
    if (view == self.btnTitleLogin) {
        [self swipeRight:nil];
    } else if (view == self.btnTitleSignup) {
        [self swipeLeft:nil];
    }
}

#pragma mark - user actions
- (IBAction)onClickForgetPass:(id)sender {
    [ViewControllerContainer showResetPass];
}

- (IBAction)onClickSignup:(id)sender {
    [self.view endEditing:YES];
    [DataManager shared].signupPagePhone = [self.fldSignupPhone.text trim];
    [DataManager shared].signupPagePass = [self.fldSignupPassword.text trim];
    VerifyPhone *request = [[VerifyPhone alloc] init];
    request.phone = [DataManager shared].signupPagePhone;
    
    [HUDUtil showWait];
    [API verifyPhone:request success:^{
        SendVerifyCode *req = [[SendVerifyCode alloc] init];
        req.phone = [DataManager shared].signupPagePhone;
        [API sendVerifyCode:req success:^{
            [ViewControllerContainer showVerifyPhone:VerfityPhoneEventSignup callback:nil];
        } failure:^{
            
        } networkError:^{
            
        }];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (IBAction)onClickLogin:(id)sender {
    [self.view endEditing:YES];
    UserLogin *login = [[UserLogin alloc] init];
    
    [login setPhone:[self.fldPhone.text trim]];
    [login setPass:[self.fldPassword.text trim]];
    
    [HUDUtil showWait];
    [API userLogin:login success:^{
        UserGetInfo *getUser = [[UserGetInfo alloc] init];
        [API userGetInfo:getUser success:^{
            [self dismissViewControllerAnimated:YES completion:^{
                [[LoginEngine shared] executeLoginBlock:YES];
            }];
        } failure:^{
        } networkError:^{
        }];
    } failure:^{

    } networkError:^{
        
    }];
}

- (IBAction)onTapWechatLogin:(id)sender {
    [[LoginEngine shared] showWechatLogin:self completion:^(BOOL logined) {
        if (logined) {
            if ([DataManager shared].isWechatFirstLogin) {
                [ViewControllerContainer showCollectDecPhase];
            } else {
                UserGetInfo *getUser = [[UserGetInfo alloc] init];
                [API userGetInfo:getUser success:^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[LoginEngine shared] executeLoginBlock:YES];
                    }];
                } failure:^{
                } networkError:^{
                }];
            }
        }
    }];
}

- (IBAction)onClickTitleLogin:(id)sender {
    [self swipeRight:nil];
}

- (IBAction)onClickTitleSignup:(id)sender {
    [self swipeLeft:nil];
}

@end
