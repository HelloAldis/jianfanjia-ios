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

@end

@implementation CustomAlertViewController

+ (void)presentOkAlert:(NSString *)title msg:(NSString *)msg {
    CustomAlertViewController *alert = [[CustomAlertViewController alloc] init];
    alert.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[ViewControllerContainer getCurrentTapController] presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


@end
