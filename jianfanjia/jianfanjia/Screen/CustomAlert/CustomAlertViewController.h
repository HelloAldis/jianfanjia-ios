//
//  CustomAlertViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef BOOL(^ButtonBlock)(id);

@interface CustomAlertViewController : BaseViewController

+ (void)presentOkAlert:(NSString *)title msg:(NSString *)msg;

@end
