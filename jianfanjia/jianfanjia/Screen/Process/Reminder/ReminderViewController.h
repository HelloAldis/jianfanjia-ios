//
//  ProcessViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface ReminderViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

- (id)initWithProcess:(NSString *)processid;
- (id)initWithProcessPreview;

@end
