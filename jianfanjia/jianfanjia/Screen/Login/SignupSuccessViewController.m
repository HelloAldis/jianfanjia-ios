//
//  SignupSuccessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SignupSuccessViewController.h"
#import "ViewControllerContainer.h"

@interface SignupSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnAddRequirement;
@property (weak, nonatomic) IBOutlet UIButton *btnBala;

@end

@implementation SignupSuccessViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnAddRequirement setCornerRadius:5];
    [self.btnBala setCornerRadius:5];
    [self.btnBala setBorder:2 andColor:[kThemeColor CGColor]];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - UI

#pragma mark - user action
- (IBAction)onClickRequirement:(id)sender {
    
}

- (IBAction)onClickBala:(id)sender {
    [ViewControllerContainer showTab];
}

@end
