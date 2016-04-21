//
//  EnumBusiness.h
//  jianfanjia
//
//  Created by Karos on 16/1/6.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#ifndef EnumBusiness_h
#define EnumBusiness_h

typedef NS_ENUM(NSInteger, VerfityPhoneEvent) {
    VerfityPhoneEventResetPassword,
    VerfityPhoneEventSignup,
    VerfityPhoneEventBindPhone,
};

typedef NS_ENUM(NSInteger, BindPhoneEvent) {
    BindPhoneEventDefault,
    BindPhoneEventOrderDesigner,
    BindPhoneEventPublishRequirement,
};

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypeAll,
    NotificationTypeAnnouncement,
    NotificationTypeRequirement,
    NotificationTypeWorksite,
};

#endif /* EnumBusiness_h */
