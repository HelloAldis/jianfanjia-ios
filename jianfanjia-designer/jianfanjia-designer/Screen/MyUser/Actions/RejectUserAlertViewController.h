//
//  CustomAlertViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

typedef void(^RejectUserBlock)(NSString *reason);

@interface RejectUserAlertViewController : UIViewController

+ (void)presentAlert:(NSString *)title msg:(NSString *)msg conform:(RejectUserBlock)agreeBlock;

@end
