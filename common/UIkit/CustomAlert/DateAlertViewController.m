//
//  CustomAlertViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DateAlertViewController.h"

@interface DateAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@property (copy, nonatomic) DateButtonBlock cancelBlock;
@property (copy, nonatomic) DateButtonBlock okBlock;

@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;

@property (assign, nonatomic) BOOL allowIgnore;

@end

@implementation DateAlertViewController

+ (void)presentAlert:(NSString *)title min:(NSDate *)minDate max:(NSDate *)maxDate cancel:(DateButtonBlock)cancelBlock ok:(DateButtonBlock)okBlock {
    DateAlertViewController *alert = [[DateAlertViewController alloc] initWithTitle:title min:minDate max:maxDate allowIgnore:NO cancel:cancelBlock ok:okBlock];
    alert.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (id)initWithTitle:(NSString *)title min:(NSDate *)minDate max:(NSDate *)maxDate allowIgnore:(BOOL)allowIgnore cancel:(DateButtonBlock)cancelBlock ok:(DateButtonBlock)okBlock {
    if (self = [super init]) {
        _alertTitle = title;
        _minDate = minDate;
        _maxDate = maxDate;
        _allowIgnore = allowIgnore;
        _cancelBlock = cancelBlock;
        _okBlock = okBlock;
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
    self.datePicker.date = self.minDate;
    self.datePicker.minimumDate = self.minDate;
    self.datePicker.maximumDate = self.maxDate;
    
    [self.alertView setCornerRadius:5];
    [self.btnCancel setCornerRadius:5];
    [self.btnCancel setBorder:1 andColor:kThemeColor.CGColor];
    [self.btnOk setCornerRadius:5];
    
    @weakify(self);
    [[self.btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.cancelBlock) {
            self.cancelBlock(nil);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[self.btnOk rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.okBlock) {
            self.okBlock(self.datePicker.date);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
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

@end
