//
//  CustomAlertViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

typedef void(^SuccessAlertButtonBlock)();

@interface SuccessAlertViewController : UIViewController

+ (void)presentAlert:(NSString *)title msg:(NSString *)msg ok:(SuccessAlertButtonBlock)okBlock;

@end
