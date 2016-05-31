//
//  ResetPassViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ResetPassViewController.h"
#import "ViewControllerContainer.h"

@interface ResetPassViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet UITextField *fldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation ResetPassViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [[[self.fldPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }] subscribeNext:^(id x) {
        self.fldPhone.text = x;
    }];
    
    [[[self.fldPassword.rac_textSignal filterNonSpace:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPasswordLength;
    }] subscribeNext:^(id x) {
        self.fldPassword.text = x;
    }];
    
    [[RACSignal
      combineLatest:@[self.fldPhone.rac_textSignal, self.fldPassword.rac_textSignal]
      reduce:^(NSString *phone, NSString *password) {
          return @([AccountBusiness validatePhone:phone] && [AccountBusiness validatePass:password]);
      }] subscribeNext:^(id x) {
          [self.btnNext enableBgColor:[x boolValue]];
      }];
    
    self.title = @"忘记密码";
    [self initLeftBackInNav];
    [self.fldPhone setCornerRadius:5];
    [self.fldPassword setCornerRadius:5];
    [self.btnNext setCornerRadius:5];
    self.btnNext.enabled = NO;
    
    [self setLeftPadding:self.fldPhone withImage:[UIImage imageNamed:@"icon_account_phone"]];
    [self setLeftPadding:self.fldPassword withImage:[UIImage imageNamed:@"icon_account_pwd"]];
}

#pragma mark - UI
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

#pragma mark - user actions
- (IBAction)onClickNext:(id)sender {
    [self.view endEditing:YES];
    [DataManager shared].signupPagePhone = self.fldPhone.text;
    [DataManager shared].signupPagePass = self.fldPassword.text;
    
    SendVerifyCode *req = [[SendVerifyCode alloc] init];
    req.phone = [DataManager shared].signupPagePhone;
    
    [HUDUtil showWait];
    [API sendVerifyCode:req success:^{
        [ViewControllerContainer showVerifyPhone:VerfityPhoneEventResetPassword];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
