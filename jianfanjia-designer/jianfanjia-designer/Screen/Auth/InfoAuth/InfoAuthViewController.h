//
//  MeViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface InfoAuthViewController : BaseViewController

- (instancetype)initWithDesigner:(Designer *)designer canEdit:(BOOL)canEdit;
- (instancetype)initWithDesigner:(Designer *)designer canEdit:(BOOL)canEdit fromRegister:(BOOL)fromRegister;

@end
