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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

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
    
    @weakify(self)
    [RACObserve(self.btnSignup, enabled) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        if (newValue.boolValue) {
            [self.btnSignup setEnableAlpha];
        } else {
            [self.btnSignup setDisableAlpha];
        }
    }];
    
    RAC(self.btnSignup, enabled) = [RACSignal
                                   combineLatest:@[self.fldVerifyCode.rac_textSignal]
                                   reduce:^(NSString *verifyCode) {
                                       return @([verifyCode trim].length > 0);
                                   }];
    
    
    [self.btnSignup setCornerRadius:5];
    self.btnSignup.enabled = NO;
    [self initLeftBackInNav];
    self.lblPhone.text = [DataManager shared].signupPagePhone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (kIs35inchScreen) {
        self.constraint.constant = 84;
    } else {
        self.constraint.constant = (kScreenHeight - 400)/2;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - user action
- (IBAction)onClickSignup:(id)sender {
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
                DesignerSignup *request = [[DesignerSignup alloc] init];
                request.phone = [DataManager shared].signupPagePhone;
                request.pass = [DataManager shared].signupPagePass;
                request.code = [self.fldVerifyCode.text trim];
                
                [HUDUtil showWait];
                [API designerSignup:request success:^{
                    [ViewControllerContainer showTab];
                } failure:^{
                    
                } networkError:^{
                    
                }];
            }
            
            break;
        case VerfityPhoneEventBindPhone: {
//                BindPhone *request = [[BindPhone alloc] init];
//                request.phone = [DataManager shared].signupPagePhone;
//                request.code = [self.fldVerifyCode.text trim];
//                
//                [HUDUtil showWait];
//                [API bindPhone:request success:^{
//                    [GVUserDefaults standardUserDefaults].phone = request.phone;
//                    [HUDUtil showSuccessText:@"绑定成功"];
//                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//                } failure:^{
//                    
//                } networkError:^{
//                    
//                }];
            }
            
            break;
        default:
            break;
    }
}

@end
