//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "EmailAuthSuccessViewController.h"
#import "DesignerAuthViewController.h"
#import "ViewControllerContainer.h"

@interface EmailAuthSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UITextField *fldEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblText1;
@property (weak, nonatomic) IBOutlet UIButton *btnModify;

@end

@implementation EmailAuthSuccessViewController

- (instancetype)initWithDesigner:(Designer *)designer {
    if (self = [super init]) {
        _designer = designer;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"邮箱认证";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    [self.iconView setCornerRadius:self.iconView.frame.size.width / 2];
    [self.btnModify setCornerRadius:5];
    [self.fldEmail setCornerRadius:5];
    [self setLeftPadding:self.fldEmail withImage:[UIImage imageNamed:@"icon_email"]];
    self.fldEmail.text = self.designer.email;
}

- (void)setLeftPadding:(UITextField *)textField withImage:(UIImage *)image {
    CGRect frame = textField.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = 60;
    UIImageView *leftview = [[UIImageView alloc] initWithFrame:frame];
    leftview.image = image;
    leftview.contentMode = UIViewContentModeCenter;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

#pragma mark - user action
- (IBAction)onClickModify:(id)sender {
    [ViewControllerContainer showEmailAuthRequest:self.designer];
}

@end
