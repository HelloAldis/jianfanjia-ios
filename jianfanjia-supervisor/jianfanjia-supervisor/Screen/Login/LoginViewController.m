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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    if (kIs35inchScreen) {
        self.topConstraint.constant = 10;
    } else {
        self.topConstraint.constant = (kScreenHeight - 480)/2 - 20;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.showSignup) {
        [self swipeLeft:nil];
    }
}

#pragma mark - UI
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

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
                            self.btnTitleLogin.alpha = 1.0;
                            self.btnTitleSignup.alpha = 0.4;
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
    }

    self.centerForBtnTitleSignup.active = YES;
    
    [UIView animateWithDuration:0.6
                          delay:0 usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.btnTitleLogin.alpha = 0.4;
                            self.btnTitleSignup.alpha = 1.0;
                            self.viewLogin.alpha = 0.0;
                            self.viewSignup.alpha = 1.0;
                            [self.view layoutIfNeeded];
                        } completion:nil];
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
            [ViewControllerContainer showVerifyPhone:VerfityPhoneEventSignup];
        } failure:^{
            
        } networkError:^{
            
        }];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (IBAction)onClickLogin:(id)sender {
    [self.view endEditing:YES];
    SupervisorLogin *login = [[SupervisorLogin alloc] init];
    
    [login setPhone:[self.fldPhone.text trim]];
    [login setPass:[self.fldPassword.text trim]];
    
    [HUDUtil showWait];
    [API supervisorLogin:login success:^{
        SupervisorGetInfo *getUser = [[SupervisorGetInfo alloc] init];
        [API supervisorGetInfo:getUser success:^{
            [ViewControllerContainer showTab];
        } failure:^{
        } networkError:^{
        }];
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
