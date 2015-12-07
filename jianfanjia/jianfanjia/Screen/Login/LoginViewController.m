//
//  LoginViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/5.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewControllerContainer.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UITextField *fldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnTitleLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnTitleSignup;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerForBtnTitleLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftForBtnTitleSignup;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UIView *viewSignup;


@property (weak, nonatomic) IBOutlet UITextField *fldSignupPhone;
@property (weak, nonatomic) IBOutlet UITextField *fldSignupPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (assign, nonatomic) BOOL isUp;
@property (strong, nonatomic) NSLayoutConstraint *leftForBtnTitleLogin;
@property (strong, nonatomic) NSLayoutConstraint *centerForBtnTitleSignup;

@end

@implementation LoginViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACObserve(self.btnLogin, enabled) subscribeNext:^(NSNumber *newValue) {
        if (newValue.boolValue) {
            [self.btnLogin setEnableAlpha];
        } else {
            [self.btnLogin setDisableAlpha];
        }
    }];
    
    [RACObserve(self.btnNext, enabled) subscribeNext:^(NSNumber *newValue) {
        if (newValue.boolValue) {
            [self.btnNext setEnableAlpha];
        } else {
            [self.btnNext setDisableAlpha];
        }
    }];
    
    [[self.fldPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }];
    
    [[self.fldSignupPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }];
    
    [[self.fldPassword.rac_textSignal filterNonSpace:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPasswordLength;
    }];
    
    [[self.fldSignupPassword.rac_textSignal filterNonSpace:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPasswordLength;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    if (kIs35inchScreen) {
        self.topConstraint.constant = 10;
    } else {
        self.topConstraint.constant = (kScreenHeight - 480)/2;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.showSignup) {
        [self swipeLeft:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI


#pragma mark - user actions
- (IBAction)swipeRight:(id)sender {
    [self.view endEditing:YES];
    self.centerForBtnTitleSignup.active = NO;
    if (!self.centerForBtnTitleLogin) {
        self.centerForBtnTitleLogin = [NSLayoutConstraint constraintWithItem:self.btnTitleLogin
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1
                                                                     constant:0];
    }
    self.centerForBtnTitleLogin.active = YES;
    [UIView animateWithDuration:0.6
                          delay:0 usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            [self.btnTitleLogin setEnableAlpha];
                            [self.btnTitleSignup setDisableAlpha];
                            self.viewLogin.alpha = 1.0;
                            self.viewSignup.alpha = 0.0;
                            [self.view layoutIfNeeded];
                        } completion:nil];

    
}
- (IBAction)swipeLeft:(id)sender {
    [self.view endEditing:YES];
    self.centerForBtnTitleLogin.active = NO;
    if (!self.centerForBtnTitleSignup) {
        self.centerForBtnTitleSignup = [NSLayoutConstraint constraintWithItem:self.btnTitleSignup
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1
                                                                     constant:0];
//        [self.view addConstraint:self.centerForBtnTitleSignup];
    }

    self.centerForBtnTitleSignup.active = YES;
    
    [UIView animateWithDuration:0.6
                          delay:0 usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            [self.btnTitleSignup setEnableAlpha];
                            [self.btnTitleLogin setDisableAlpha];
//                            self.viewLogin.hidden = YES;
//                            self.viewSignup.hidden = NO;
                            self.viewLogin.alpha = 0.0;
                            self.viewSignup.alpha = 1.0;
                            [self.view layoutIfNeeded];
                        } completion:nil];
}



- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.isUp) {
        NSDictionary *userInfo = [notification userInfo];
        
        // get keyboard rect in windwo coordinate
    DDLogDebug(@"%@", [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]);
        
        // get keybord anmation duration
        NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:animationDuration
                              delay:0 usingSpringWithDamping:1.0
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveLinear animations:^{
                                [self.view layoutIfNeeded];
                            } completion:nil];
        
        self.isUp = YES;
    }

}

- (void) keyboardWillHide:(NSNotification *)notification {
    if (self.isUp) {
        NSDictionary *userInfo = [notification userInfo];
        
        // get keyboard rect in windwo coordinate
        
        // get keybord anmation duration
        NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:animationDuration
                              delay:0 usingSpringWithDamping:1.0
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveLinear animations:^{
                                [self.view layoutIfNeeded];
                            } completion:nil];

        self.isUp = NO;
    }
}

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
            [ViewControllerContainer showVerifyPhone:NO];
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
        [GVUserDefaults standardUserDefaults].isLogin = YES;
        [ViewControllerContainer showTab];
    } failure:^{

    } networkError:^{
        
    }];
}

- (IBAction)onClickTitleLogin:(id)sender {
    if (self.viewLogin.alpha == 0.0) {
        [self swipeRight:nil];
    }
}

- (IBAction)onClickTitleSignup:(id)sender {
    if (self.viewSignup.alpha == 0.0) {
        [self swipeLeft:nil];
    }
}

@end
