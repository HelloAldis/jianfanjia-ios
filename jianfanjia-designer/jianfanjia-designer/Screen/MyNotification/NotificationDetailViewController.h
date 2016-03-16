//
//  NotificationDetailViewController.h
//  jianfanjia
//
//  Created by Karos on 16/3/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface NotificationDetailViewController : BaseViewController

@property (nonatomic, strong) NSString *notificationId;
@property (nonatomic, copy) NotificationReadBlock readBlock;

@end
