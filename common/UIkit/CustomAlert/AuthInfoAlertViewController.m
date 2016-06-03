//
//  CustomAlertViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AuthInfoAlertViewController.h"

@interface AuthInfoAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@property (strong, nonatomic) NSString *alertMessage;

@property (copy, nonatomic) AuthInfoAlertButtonBlock okBlock;

@property (assign, nonatomic) BOOL allowIgnore;

@end

@implementation AuthInfoAlertViewController

+ (void)presentAlert:(AuthInfoAlertButtonBlock)okBlock {
    [self presentAlert:nil ok:okBlock];
}

+ (void)presentAlert:(NSString *)msg ok:(AuthInfoAlertButtonBlock)okBlock {
    AuthInfoAlertViewController *alert = [[AuthInfoAlertViewController alloc] initWithMessage:msg allowIgnore:NO ok:okBlock];
    alert.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (id)initWithMessage:(NSString *)message allowIgnore:(BOOL)allowIgnore ok:(AuthInfoAlertButtonBlock)okBlock {
    if (self = [super init]) {
        _alertMessage = message;
        _allowIgnore = allowIgnore;
        _okBlock = okBlock;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - init UI
- (void)initUI {
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapParentView:)]];
    static NSString *deafultMsg = @"您是否提交本次认证申请？\n我们的工作人员会在12小时之内为您认证\n您也可以前往认证中心完善其他资料认证";
    self.lblMessage.text = self.alertMessage ? self.alertMessage : deafultMsg;
    [self.lblMessage setRowSpace:12.0];
    
    [self.alertView setCornerRadius:5];
    [self.btnCancel setBorder:1 andColor:kThemeColor.CGColor];
    [self.btnCancel setCornerRadius:5];
    [self.btnOk setCornerRadius:5];
    
    @weakify(self);
    [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self invokeBlock:self.okBlock];
    }];
    
    [[self.btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self invokeBlock:nil];
    }];
}

#pragma mark - gesture
- (void)handleTapParentView:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    CGPoint pointForTargetView = [self.alertView convertPoint:point fromView:gesture.view];
    
    if (!CGRectContainsPoint(self.alertView.bounds, pointForTargetView) && self.allowIgnore) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - block invoke 
- (void)invokeBlock:(AuthInfoAlertButtonBlock)block {
    [self dismissViewControllerAnimated:YES completion:^{
        if (block) {
            block();
        }
    }];
}

@end
