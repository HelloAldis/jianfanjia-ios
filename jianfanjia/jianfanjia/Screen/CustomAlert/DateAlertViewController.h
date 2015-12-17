//
//  CustomAlertViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DateButtonBlock)(id date);

@interface DateAlertViewController : BaseViewController

+ (void)presentAlert:(NSString *)title min:(NSDate *)minDate max:(NSDate *)maxDate cancel:(DateButtonBlock)cancelBlock ok:(DateButtonBlock)okBlock;

@end
