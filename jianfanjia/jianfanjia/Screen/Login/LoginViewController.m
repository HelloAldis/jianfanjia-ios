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

static CGFloat kImageOriginHight = 0;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *loginAngleUp;
@property (weak, nonatomic) IBOutlet UIImageView *signupAngleUp;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UITextField *fldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnTitleLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnTitleSignup;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UIView *viewSignup;

@property (weak, nonatomic) IBOutlet UITextField *fldSignupPhone;
@property (weak, nonatomic) IBOutlet UITextField *fldSignupPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (assign, nonatomic) BOOL isUp;
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
//    [self.navigationController setNavigationBarHidden:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.showSignup) {
        [self swipeLeft:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)onClickBack {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    self.btnLogin.enabled = NO;
    [self.btnNext setCornerRadius:5];
    self.btnNext.enabled = NO;
    self.isUp = NO;
    self.isShowingLogin = YES;
    self.loginAngleUp.hidden = !self.isShowingLogin;
    self.signupAngleUp.hidden = self.isShowingLogin;
    
    [self setLeftPadding:self.fldPhone withImage:[UIImage imageNamed:@"icon_account_phone"]];
    [self setLeftPadding:self.fldPassword withImage:[UIImage imageNamed:@"icon_account_pwd"]];
    [self setLeftPadding:self.fldSignupPhone withImage:[UIImage imageNamed:@"icon_account_phone"]];
    [self setLeftPadding:self.fldSignupPassword withImage:[UIImage imageNamed:@"icon_account_pwd"]];
    
    [self initTopImageView];
}

- (void)initTopImageView {
    CGFloat aspect =  414.0 / kScreenWidth;
    kImageOriginHight = round(270 / aspect);
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kImageOriginHight, kScreenWidth, kImageOriginHight)];
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.image = [UIImage imageNamed:@"bg_login"];
    self.scrollView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    [self.scrollView addSubview:self.topImageView];
}

- (void)setLeftPadding:(UITextField *)textField withImage:(UIImage *)image {
    CGRect frame = textField.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = 30;
    UIImageView *leftview = [[UIImageView alloc] initWithFrame:frame];
    leftview.image = image;
    leftview.contentMode = UIViewContentModeLeft;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.topImageView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.topImageView.frame = f;
    } else if (yOffset >= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - user actions
- (IBAction)swipeRight:(id)sender {
    [self.view endEditing:YES];
   
    if (!self.isShowingLogin) {
        self.isShowingLogin = YES;
        
        CGRect frame = self.viewLogin.frame;
        frame.origin.x = -kScreenWidth;
        self.viewLogin.frame = frame;
        self.viewLogin.alpha = 1;
        self.viewSignup.alpha = 1;

        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.viewLogin.frame;
            frame.origin.x = 0;
            self.viewLogin.frame = frame;
            
            frame = self.viewSignup.frame;
            frame.origin.x = kScreenWidth;
            self.viewSignup.frame = frame;
            
            self.loginAngleUp.hidden = !self.isShowingLogin;
            self.signupAngleUp.hidden = self.isShowingLogin;
            
            [self.btnTitleLogin setEnableAlpha];
            [self.btnTitleSignup setDisableAlpha];
        } completion:^(BOOL finished) {
            self.viewSignup.alpha = 0;
        }];
    }
}

- (IBAction)swipeLeft:(id)sender {
    [self.view endEditing:YES];
    
    if (self.isShowingLogin) {
        self.isShowingLogin = NO;
        
        CGRect frame = self.viewSignup.frame;
        frame.origin.x = kScreenWidth;
        self.viewSignup.frame = frame;
        self.viewSignup.alpha = 1;
        self.viewLogin.alpha = 1;
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.viewSignup.frame;
            frame.origin.x = 0;
            self.viewSignup.frame = frame;
            
            frame = self.viewLogin.frame;
            frame.origin.x = -kScreenWidth;
            self.viewLogin.frame = frame;
            
            self.loginAngleUp.hidden = !self.isShowingLogin;
            self.signupAngleUp.hidden = self.isShowingLogin;
            
            [self.btnTitleSignup setEnableAlpha];
            [self.btnTitleLogin setDisableAlpha];
        } completion:^(BOOL finished) {
            self.viewLogin.alpha = 0;
        }];
    }
}

//- (void)keyboardWillShow:(NSNotification *)notification {
//    if (!self.isUp) {
//        NSDictionary *userInfo = [notification userInfo];
//        
//        // get keyboard rect in windwo coordinate
//    DDLogDebug(@"%@", [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]);
//        
//        // get keybord anmation duration
//        NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        
//        [UIView animateWithDuration:animationDuration
//                              delay:0 usingSpringWithDamping:1.0
//              initialSpringVelocity:1.0
//                            options:UIViewAnimationOptionCurveLinear animations:^{
//                                [self.view layoutIfNeeded];
//                            } completion:nil];
//        
//        self.isUp = YES;
//    }
//
//}
//
//- (void) keyboardWillHide:(NSNotification *)notification {
//    if (self.isUp) {
//        NSDictionary *userInfo = [notification userInfo];
//        
//        // get keyboard rect in windwo coordinate
//        
//        // get keybord anmation duration
//        NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        
//        [UIView animateWithDuration:animationDuration
//                              delay:0 usingSpringWithDamping:1.0
//              initialSpringVelocity:1.0
//                            options:UIViewAnimationOptionCurveLinear animations:^{
//                                [self.view layoutIfNeeded];
//                            } completion:nil];
//
//        self.isUp = NO;
//    }
//}

- (IBAction)onClickForgetPass:(id)sender {
    [ViewControllerContainer showResetPass];
}

- (IBAction)onClickSignup:(id)sender {
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
            [ViewControllerContainer showTab];
        } failure:^{
        } networkError:^{
        }];
    } failure:^{

    } networkError:^{
        
    }];
}

- (IBAction)onClickTitleLogin:(id)sender {
    [self swipeRight:nil];
}

- (IBAction)onClickTitleSignup:(id)sender {
    [self swipeLeft:nil];
}

@end
