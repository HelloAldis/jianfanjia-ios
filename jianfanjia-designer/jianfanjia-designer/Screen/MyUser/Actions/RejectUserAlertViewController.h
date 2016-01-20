//
//  CustomAlertViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

typedef void(^MessageButtonBlock)();

@interface RejectUserAlertViewController : UIViewController

+ (void)presentAlert:(NSString *)title msg:(NSString *)msg second:(NSString *)second ok:(MessageButtonBlock)okBlock;
+ (void)presentAlert:(NSString *)title msg:(NSString *)msg second:(NSString *)second okTitle:(NSString *)okTitle ok:(MessageButtonBlock)okBlock;
+ (void)presentAlert:(NSString *)title msg:(NSString *)msg second:(NSString *)second reject:(MessageButtonBlock)rejectBlock agree:(MessageButtonBlock)agreeBlock;
+ (void)presentAlert:(NSString *)title msg:(NSString *)msg second:(NSString *)second rejectTitle:(NSString *)rejectTitle reject:(MessageButtonBlock)rejectBlock agreeTitle:(NSString *)agreeTitle agree:(MessageButtonBlock)agreeBlock;

@end
