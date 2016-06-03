//
//  CustomAlertViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

typedef void(^AuthInfoAlertButtonBlock)();

@interface AuthInfoAlertViewController : UIViewController

+ (void)presentAlert:(AuthInfoAlertButtonBlock)okBlock;
+ (void)presentAlert:(NSString *)msg ok:(AuthInfoAlertButtonBlock)okBlock;

@end
