//
//  CustomAlertViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^MessageButtonBlock)();

@interface MessageAlertViewController : BaseViewController

+ (void)presentAlert:(NSString *)title msg:(NSString *)msg second:(NSString *)second ok:(MessageButtonBlock)okBlock;
+ (void)presentAlert:(NSString *)title msg:(NSString *)msg second:(NSString *)second reject:(MessageButtonBlock)rejectBlock agree:(MessageButtonBlock)agreeBlock;

@end
