//
//  CustomAlertViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RejectUserAlertViewController.h"

@interface RejectUserAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *checkViews;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkBtns;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *checkLabels;

@property (assign, nonatomic) NSInteger curSelectedIdx;

@property (copy, nonatomic) RejectUserBlock agreeBlock;

@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSString *alertMessage;

@property (assign, nonatomic) BOOL allowIgnore;
@property (assign, nonatomic) BOOL isInTapping;

@end

@implementation RejectUserAlertViewController

+ (void)presentAlert:(NSString *)title msg:(NSString *)msg conform:(RejectUserBlock)agreeBlock {
    RejectUserAlertViewController *alert = [[RejectUserAlertViewController alloc] initWithTitle:title message:msg allowIgnore:YES agree:agreeBlock];
    alert.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message allowIgnore:(BOOL)allowIgnore agree:(RejectUserBlock)agreeBlock {
    if (self = [super init]) {
        _alertTitle = title;
        _alertMessage = message;
        _allowIgnore = allowIgnore;
        _agreeBlock = agreeBlock;
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
    
    @weakify(self);
    [self.checkViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCheckView:)]];
    }];
    
    self.curSelectedIdx = -1;
    self.lblTitle.text = self.alertTitle;
    self.lblMessage.text = self.alertMessage;
    [self.alertView setCornerRadius:5];
    [self.btnReject setCornerRadius:5];
    [self.btnReject setBorder:1 andColor:kFinishedColor.CGColor];
    [self.btnAgree setCornerRadius:5];
    
    [self.btnReject setNormTitle:@"取消"];
    [self.btnAgree setNormTitle:@"确定"];
    
    [RACObserve(self, curSelectedIdx) subscribeNext:^(id x) {
        @strongify(self);
        self.btnAgree.enabled = [x integerValue] > -1;
        self.btnAgree.backgroundColor = self.btnAgree.enabled ? kFinishedColor : kUntriggeredColor;
    }];
    
    [[self.btnReject rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.agreeBlock) {
            self.agreeBlock(nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[self.btnAgree rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.agreeBlock) {
            self.agreeBlock([self.checkLabels[self.curSelectedIdx] text]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - gesture
- (void)handleTapParentView:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    CGPoint pointForTargetView = [self.alertView convertPoint:point fromView:gesture.view];
    
    if (!CGRectContainsPoint(self.alertView.bounds, pointForTargetView) && self.allowIgnore) {
        if (self.agreeBlock) {
            self.agreeBlock(nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)handleTapCheckView:(UIGestureRecognizer *)gesture {
    if (self.isInTapping) {
        return;
    }
    
    self.isInTapping = YES;
    [self.checkBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setNormImg:[UIImage imageNamed:@"unchecked"]];
    }];
    
    NSInteger selectedIdx = [self.checkViews indexOfObject:gesture.view];
    UIButton *selectedButton = self.checkBtns[selectedIdx];
    [selectedButton setNormImg:[UIImage imageNamed:@"checked"]];
    
    self.curSelectedIdx = selectedIdx;
    self.isInTapping = NO;
}

@end
