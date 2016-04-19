//
//  VerifyPhoneViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "ViewControllerContainer.h"

@interface BindPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fldPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnBind;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@property (assign, nonatomic) BindPhoneEvent bindPhoneEvent;

@end

@implementation BindPhoneViewController

#pragma mark - init method
- (id)initWithEvent:(BindPhoneEvent)bindPhoneEvent {
    if (self = [super init]) {
        self.bindPhoneEvent = bindPhoneEvent;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavi];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (kIs35inchScreen) {
        self.constraint.constant = 84;
    } else {
        self.constraint.constant = (kScreenHeight - 400)/2;
    }
}

- (void)initNavi {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUI {
    @weakify(self)
    [RACObserve(self.btnBind, enabled) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        [self.btnBind enableBgColor:newValue.boolValue];
    }];
    
    [[[self.fldPhone.rac_textSignal filterNonDigit:^BOOL{
        return YES;
    }] length:^NSInteger{
        return kPhoneLength;
    }] subscribeNext:^(id x) {
        self.fldPhone.text = x;
        self.btnBind.enabled = [x trim].length == kPhoneLength;
    }];
    
    [self.btnBind setCornerRadius:5];
    self.btnBind.enabled = NO;
    [self initLeftBackInNav];
    
    self.lblMessage.text = @"您的手机号仅用于我们为您提供便捷的服务\n绝不做任何商业用途";
}

#pragma mark - user action
- (void)onClickBack {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBind:(id)sender {
    VerifyPhone *request = [[VerifyPhone alloc] init];
    request.phone = self.fldPhone.text;
    
    [HUDUtil showWait];
    [API verifyPhone:request success:^{
        SendVerifyCode *req = [[SendVerifyCode alloc] init];
        req.phone = request.phone;
        [API sendVerifyCode:req success:^{
            [DataManager shared].signupPagePhone = request.phone;
            [ViewControllerContainer showVerifyPhone:VerfityPhoneEventBindPhone callback:self.callback];
        } failure:^{
            
        } networkError:^{
            
        }];
    } failure:^{
        
    } networkError:^{
        
    }];
}


@end
