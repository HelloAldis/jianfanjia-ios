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

    [[self.fldPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }];
    
    [[self.fldPassword.rac_textSignal filterNonSpace:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPasswordLength;
    }];
    
    [RACObserve(self.btnNext, enabled) subscribeNext:^(NSNumber *newValue) {
        if (newValue.boolValue) {
            [self.btnNext setEnableAlpha];
        } else {
            [self.btnNext setDisableAlpha];
        }
    }];
    
    RAC(self.btnNext, enabled) = [RACSignal
                                  combineLatest:@[self.fldPhone.rac_textSignal, self.fldPassword.rac_textSignal]
                                  reduce:^(NSString *phone, NSString *password) {
                                      return @([AccountBusiness validatePhone:phone] && [AccountBusiness validatePass:password]);
                                  }];
    [self initLeftBackInNav];
    [self.btnNext setCornerRadius:5];
    self.btnNext.enabled = NO;
}

#pragma mark - UI

#pragma mark - user actions
- (IBAction)onClickNext:(id)sender {
    [DataManager shared].signupPagePhone = self.fldPhone.text;
    [DataManager shared].signupPagePass = self.fldPassword.text;
    
    SendVerifyCode *req = [[SendVerifyCode alloc] init];
    req.phone = [DataManager shared].signupPagePhone;
    
    [HUDUtil showWait];
    [API sendVerifyCode:req success:^{
        [HUDUtil hideWait];
        [ViewControllerContainer showVerifyPhone:YES];
    } failure:^{
        [HUDUtil hideWait];
    }];
}



@end
