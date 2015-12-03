//
//  CustomAlertViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CustomAlertViewController.h"
#import "ViewControllerContainer.h"

@interface CustomAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (copy, nonatomic) ButtonBlock rejectBlock;
@property (copy, nonatomic) ButtonBlock agreeBlock;
@property (copy, nonatomic) ButtonBlock okBlock;

@end

@implementation CustomAlertViewController

+ (void)presentOkAlert:(NSString *)title msg:(NSString *)msg {
    CustomAlertViewController *alert = [[CustomAlertViewController alloc] init];
    alert.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[ViewControllerContainer getCurrentTapController] presentViewController:alert animated:YES completion:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message content:(UIView *)content allowIgnore:(BOOL)allowIgnore reject:(ButtonBlock)rejectBlock agree:(ButtonBlock)agreeBlock ok:(ButtonBlock)okBlock {
    if (self = [super init]) {
        
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
    [self.alertView setCornerRadius:5];
    [self.btnReject setCornerRadius:5];
    [self.btnReject setBorder:1 andColor:kFinishedColor.CGColor];
    [self.btnAgree setCornerRadius:5];
    [self.btnOk setCornerRadius:5];
    
    self.contentViewHeightConstraint.constant = 200;
}

#pragma mark - gesture
- (void)handleTapParentView:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    CGPoint pointForTargetView = [self.alertView convertPoint:point fromView:gesture.view];
    
    if (!CGRectContainsPoint(self.alertView.bounds, pointForTargetView)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
