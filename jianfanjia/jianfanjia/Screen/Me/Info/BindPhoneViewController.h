//
//  VerifyPhoneViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface BindPhoneViewController : BaseViewController

@property (nonatomic, copy) void (^callback)(void);

- (id)initWithEvent:(BindPhoneEvent)bindPhoneEvent;

@end
