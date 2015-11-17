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

@end

@implementation VerifyPhoneViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACObserve(self.btnSignup, enabled) subscribeNext:^(NSNumber *newValue) {
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
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (kIs35inchScreen) {
//        self.topConstraint.constant = 10;
    } else {
//        self.topConstraint.constant = (kScreenHeight - 480)/2;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)onClickSignup:(id)sender {
    if (self.isResetPass) {
        UpdatePass *request = [[UpdatePass alloc] init];
        request.phone = [DataManager shared].signupPagePhone;
        request.pass = [DataManager shared].signupPagePass;
        request.code = [self.fldVerifyCode.text trim];
        
        [HUDUtil showWait];
        [API updatePass:request success:^{
            [HUDUtil hideWait];
            [HUDUtil showSuccessText:@"密码更新成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^{
            [HUDUtil hideWait];
        }];
    } else {
        UserSignup *request = [[UserSignup alloc] init];
        request.phone = [DataManager shared].signupPagePhone;
        request.pass = [DataManager shared].signupPagePass;
        request.code = [self.fldVerifyCode.text trim];
        
        [HUDUtil showWait];
        [API userSignup:request success:^{
            [HUDUtil hideWait];
            [GVUserDefaults standardUserDefaults].isLogin = YES;
            [ViewControllerContainer showSignupSuccess];
        } failure:^{
            [HUDUtil hideWait];
        }];
    }
}

@end
