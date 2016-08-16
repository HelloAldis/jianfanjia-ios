//
//  CustomAlertViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SuccessAlertViewController.h"

@interface SuccessAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSString *alertMessage;

@property (copy, nonatomic) SuccessAlertButtonBlock okBlock;

@property (assign, nonatomic) BOOL allowIgnore;

@end

@implementation SuccessAlertViewController

+ (void)presentAlert:(NSString *)title msg:(NSString *)msg ok:(SuccessAlertButtonBlock)okBlock {
    SuccessAlertViewController *alert = [[SuccessAlertViewController alloc] initWithTitle:title message:msg allowIgnore:NO ok:okBlock];
    alert.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message allowIgnore:(BOOL)allowIgnore ok:(SuccessAlertButtonBlock)okBlock {
    if (self = [super init]) {
        _alertTitle = title;
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
    self.lblTitle.text = self.alertTitle;
    self.lblMessage.text = self.alertMessage;
    [self.lblMessage setRowSpace:12.0];
    
    [self.alertView setCornerRadius:5];
    [self.btnOk setCornerRadius:5];
    
    @weakify(self);
    [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self invokeBlock:self.okBlock];
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
- (void)invokeBlock:(SuccessAlertButtonBlock)block {
    [self dismissViewControllerAnimated:YES completion:^{
        if (block) {
            block();
        }
    }];
}

@end
