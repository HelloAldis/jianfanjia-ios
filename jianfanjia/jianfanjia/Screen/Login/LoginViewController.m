//
//  LoginViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/5.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+Ex.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *fldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginConstraint;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.btnLogin setCornerRadius:5];
    
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
    NSDictionary *userInfo = [notification userInfo];
    
    // get keyboard rect in windwo coordinate
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get keybord anmation duration
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.loginConstraint.constant += keyboardRect.size.height;
    
    [UIView animateWithDuration:animationDuration
                          delay:0 usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            [self.view layoutIfNeeded];
                        } completion:nil];
//
//    [UIView transitionWithView:self.btnLogin
//                      duration:animationDuration
//                       options:UIViewAnimationOptionCurveLinear animations:^{
//                         self.loginConstraint.constant += keyboardRect.size.height;
//                           [self.view layoutIfNeeded];
//    } completion:nil];
}

- (void) keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // get keyboard rect in windwo coordinate
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get keybord anmation duration
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    [UIView animateWithDuration:animationDuration animations:^{
//        self.loginConstraint.constant -= keyboardRect.size.height;
//    }];
    
    [UIView animateWithDuration:5
                          delay:0 usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.loginConstraint.constant -= keyboardRect.size.height;
                        } completion:nil];

}
- (IBAction)onClickForgetPass:(id)sender {
    
}

- (IBAction)onClickSignup:(id)sender {
    
}

- (IBAction)onClickLogin:(id)sender {

}

@end
