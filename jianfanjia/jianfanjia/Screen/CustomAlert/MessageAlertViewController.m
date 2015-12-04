//
//  CustomAlertViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MessageAlertViewController.h"
#import "ViewControllerContainer.h"

@interface MessageAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblThirdMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@property (copy, nonatomic) MessageButtonBlock rejectBlock;
@property (copy, nonatomic) MessageButtonBlock agreeBlock;
@property (copy, nonatomic) MessageButtonBlock okBlock;

@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSString *alertMessage;
@property (strong, nonatomic) NSString *alertSecondMsg;
@property (strong, nonatomic) NSString *alertThirdMsg;

@property (assign, nonatomic) BOOL allowIgnore;

@end

@implementation MessageAlertViewController

+ (void)presentAlert:(NSString *)title msg:(NSString *)msg second:(NSString *)second ok:(MessageButtonBlock)okBlock {
    MessageAlertViewController *alert = [[MessageAlertViewController alloc] initWithTitle:title message:msg secondMsg:second thirdMsg:nil allowIgnore:NO reject:nil agree:nil ok:okBlock];
    alert.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[ViewControllerContainer getCurrentTapController] presentViewController:alert animated:YES completion:nil];
}

+ (void)presentAlert:(NSString *)title msg:(NSString *)msg second:(NSString *)second reject:(MessageButtonBlock)rejectBlock agree:(MessageButtonBlock)agreeBlock {
    MessageAlertViewController *alert = [[MessageAlertViewController alloc] initWithTitle:title message:msg secondMsg:second thirdMsg:nil allowIgnore:YES reject:rejectBlock agree:agreeBlock ok:nil];
    alert.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[ViewControllerContainer getCurrentTapController] presentViewController:alert animated:YES completion:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message secondMsg:(NSString *)secondMsg thirdMsg:(NSString *)thirdMsg allowIgnore:(BOOL)allowIgnore reject:(MessageButtonBlock)rejectBlock agree:(MessageButtonBlock)agreeBlock ok:(MessageButtonBlock)okBlock {
    if (self = [super init]) {
        _alertTitle = title;
        _alertMessage = message;
        _alertSecondMsg = secondMsg;
        _alertThirdMsg = thirdMsg;
        _allowIgnore = allowIgnore;
        _rejectBlock = rejectBlock;
        _agreeBlock = agreeBlock;
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
    self.lblSecondMessage.text = self.alertSecondMsg;
    self.lblThirdMessage.text = self.alertThirdMsg;
    
    [self.alertView setCornerRadius:5];
    [self.btnReject setCornerRadius:5];
    [self.btnReject setBorder:1 andColor:kFinishedColor.CGColor];
    [self.btnAgree setCornerRadius:5];
    [self.btnOk setCornerRadius:5];
    
    if (self.rejectBlock || self.agreeBlock) {
        self.btnReject.hidden = NO;
        self.btnAgree.hidden = NO;
        self.btnOk.hidden = YES;
    } else {
        self.btnReject.hidden = YES;
        self.btnAgree.hidden = YES;
        self.btnOk.hidden = NO;
    }
    
    @weakify(self);
    [[self.btnReject rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self invokeBlock:self.rejectBlock];
    }];
    
    [[self.btnAgree rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self invokeBlock:self.agreeBlock];
    }];
    
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
- (void)invokeBlock:(MessageButtonBlock)block {
    if (block) {
        block();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
