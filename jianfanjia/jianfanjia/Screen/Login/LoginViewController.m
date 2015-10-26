//
//  LoginViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/5.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "LoginViewController.h"
#import "API.h"
#import "ViewControllerContainer.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *fldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoWidthConstraint;

@property (assign, nonatomic) BOOL isUp;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACObserve(self.btnLogin, enabled) subscribeNext:^(NSNumber *newValue) {
        if (newValue.boolValue) {
            [self.btnLogin setEnableAlpha];
        } else {
            [self.btnLogin setDisableAlpha];
        }
    }];
    
    RAC(self.btnLogin, enabled) = [RACSignal
                                   combineLatest:@[self.fldPhone.rac_textSignal, self.fldPassword.rac_textSignal]
                                   reduce:^(NSString *phone, NSString *password) {
                                       return @([AccountBusiness validateLogin:phone pass:password]);
                                   }];
    
    
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.btnLogin setCornerRadius:5];
    [self.btnLogin setDisableAlpha];
    self.btnLogin.enabled = NO;
    self.isUp = NO;

    UIColor *color = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1.0];
    self.fldPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.fldPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入账号" attributes:@{NSForegroundColorAttributeName: color}];


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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.isUp) {
        NSDictionary *userInfo = [notification userInfo];
        
        // get keyboard rect in windwo coordinate
        CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        // get keybord anmation duration
        NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        self.loginConstraint.constant += (keyboardRect.size.height - 90);
        self.logoImageView.image = [UIImage imageNamed:@"logo_loading-1"];
        self.logoWidthConstraint.constant = 134;
        self.logoHeightConstraint.constant = 40;
        
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
        CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        // get keybord anmation duration
        NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        self.loginConstraint.constant -= (keyboardRect.size.height - 90);
        self.logoImageView.image = [UIImage imageNamed:@"logo_loading"];
        self.logoWidthConstraint.constant = 125;
        self.logoHeightConstraint.constant = 132;
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
    
}

- (IBAction)onClickSignup:(id)sender {
    
}

- (IBAction)onClickLogin:(id)sender {
    Login *login = [[Login alloc] init];
    
    [login setPhone:[self.fldPhone.text trim]];
    [login setPass:[self.fldPassword.text trim]];
    
    [HUDUtil showWait];
    [API login:login success:^{
        [API getProcessList:[[ProcessList alloc] init] success:^{
            GetProcess *request = [[GetProcess alloc] init];
            request.processid = [GVUserDefaults standardUserDefaults].processid;
            [API getProcess:request success:^{
                [HUDUtil hideWait];
                [GVUserDefaults standardUserDefaults].isLogin = YES;
                [ViewControllerContainer showProcess];
            } failure:^{
                [HUDUtil hideWait];
            }];
        } failure:^{
            [HUDUtil hideWait];
        }];

    } failure:^{
        [HUDUtil hideWait];
    }];
}



@end
