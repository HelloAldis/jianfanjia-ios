//
//  LoginBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/9/15.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WELCOME_VERSION 1
#define USER_TYPE_USER @"1"
#define USER_TYPE_DESIGNER @"2"

#define THEME_COLOR [UIColor colorWithRed:254/255.0f green:112/255.0f blue:3/255.0f alpha:1.0]

#define PROCESS_ITEM_STATUS_NEW @"0"
#define PROCESS_ITEM_STATUS_GOING @"1"
#define PROCESS_ITEM_STATUS_DONE @"2"
#define PROCESS_ITEM_STATUS_RESCHEDULE_REQ_NEW @"3"
#define PROCESS_ITEM_STATUS_RESCHEDULE_OK @"4"
#define PROCESS_ITEM_STATUS_RESCHEDULE_REJECT @"5"


@interface Business : NSObject

+ (BOOL)validateLogin:(NSString *)phone pass:(NSString *)pass;
+ (UIImage *)defaultAvatar;
+ (NSInteger)sectionCount;

@end
