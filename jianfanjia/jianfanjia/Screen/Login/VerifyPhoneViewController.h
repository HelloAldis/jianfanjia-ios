//
//  VerifyPhoneViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface VerifyPhoneViewController : BaseViewController

@property (nonatomic, copy) void (^callback)(void);

- (id)initWithEvent:(VerfityPhoneEvent)verfityPhoneEvent;

@end
