//
//  VerifyPhoneViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#import "ViewControllerContainer.h"

@interface VerifyPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fldVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@property (assign, nonatomic) VerfityPhoneEvent verfityPhoneEvent;

@end

@implementation VerifyPhoneViewController

#pragma mark - init method 
- (id)initWithEvent:(VerfityPhoneEvent)verfityPhoneEvent {
    if (self = [super init]) {
        self.verfityPhoneEvent = verfityPhoneEvent;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [[RACSignal
      combineLatest:@[self.fldVerifyCode.rac_textSignal]
      reduce:^(NSString *verifyCode) {
         return @([verifyCode trim].length > 0);
      }] subscribeNext:^(id x) {
          [self.btnSignup enableBgColor:[x boolValue]];
      }];
    
    self.title = @"验证手机";
    [self initLeftBackInNav];
    [self.fldVerifyCode setCornerRadius:5];
    [self.btnSignup setCornerRadius:5];
    self.btnSignup.enabled = NO;
    self.lblPhone.text = [DataManager shared].signupPagePhone;
}

#pragma mark - user action
- (IBAction)onClickSignup:(id)sender {
    [self.view endEditing:YES];
    switch (self.verfityPhoneEvent) {
        case VerfityPhoneEventResetPassword: {
                UpdatePass *request = [[UpdatePass alloc] init];
                request.phone = [DataManager shared].signupPagePhone;
                request.pass = [DataManager shared].signupPagePass;
                request.code = [self.fldVerifyCode.text trim];
                
                [HUDUtil showWait];
                @weakify(self);
                [API updatePass:request success:^{
                    @strongify(self);
                    [HUDUtil showSuccessText:@"密码更新成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } failure:^{
                    
                } networkError:^{
                    
                }];
            }
            
            break;
        case VerfityPhoneEventSignup: {
                UserSignup *request = [[UserSignup alloc] init];
                request.phone = [DataManager shared].signupPagePhone;
                request.pass = [DataManager shared].signupPagePass;
                request.code = [self.fldVerifyCode.text trim];
                
                [HUDUtil showWait];
                [API userSignup:request success:^{
                    [[LoginEngine shared] postLoginEvent];
                    [ViewControllerContainer showCollectDecPhase];
                } failure:^{
                    
                } networkError:^{
                    
                }];
            }
            
            break;
        case VerfityPhoneEventBindPhone: {
                BindPhone *request = [[BindPhone alloc] init];
                request.phone = [DataManager shared].signupPagePhone;
                request.code = [self.fldVerifyCode.text trim];
                
                [HUDUtil showWait];
                [API bindPhone:request success:^{
                    [GVUserDefaults standardUserDefaults].phone = request.phone;
//                    [HUDUtil showSuccessText:@"绑定成功"];
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                        if (self.callback) {
                            self.callback();
                        }
                    }];
                } failure:^{
                    
                } networkError:^{
                    
                }];
            }
            
            break;
        default:
            break;
    }
}

@end
