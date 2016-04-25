//
//  DesignerBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CommentBusiness.h"

@implementation CommentBusiness

+ (NSString *)imageId:(Comment *)comment {
    NSString *imageId = nil;
    
    if ([comment.usertype isEqualToString:kUserTypeUser]) {
        imageId = comment.user.imageid;
    } else if ([comment.usertype isEqualToString:kUserTypeDesigner]) {
        imageId = comment.designer.imageid;
    } else if ([comment.usertype isEqualToString:kUserTypeSupervisor]) {
        imageId = comment.supervisor.imageid;
    }
    
    return imageId;
}

+ (NSString *)userName:(Comment *)comment {
    NSString *userName = nil;
    
    if ([comment.usertype isEqualToString:kUserTypeUser]) {
        userName = comment.user.username;
    } else if ([comment.usertype isEqualToString:kUserTypeDesigner]) {
        userName = comment.designer.username;
    } else if ([comment.usertype isEqualToString:kUserTypeSupervisor]) {
        userName = comment.supervisor.username;
    }
    
    return userName;
}

+ (UIColor *)roleColor:(Comment *)comment {
    UIColor *color = nil;
    
    if ([comment.usertype isEqualToString:kUserTypeUser]) {
        color = kThemeColor;
    } else if ([comment.usertype isEqualToString:kUserTypeDesigner]) {
        color = kExcutionStatusColor;
    } else if ([comment.usertype isEqualToString:kUserTypeSupervisor]) {
        color = kPassStatusColor;
    }

    return color;
}

+ (NSString *)imageIdByNoti:(BaseNotification *)noti {
    NSString *imageId = nil;
    
    if (noti.user._id) {
        imageId = noti.user.imageid;
    } else if (noti.designer._id) {
        imageId = noti.designer.imageid;
    } else if (noti.supervisor._id) {
        imageId = noti.supervisor.imageid;
    }
    
    return imageId;
}

+ (NSString *)userNameByNoti:(BaseNotification *)noti {
    NSString *userName = nil;
    
    if (noti.user._id) {
        userName = noti.user.username;
    } else if (noti.designer._id) {
        userName = noti.designer.username;
    } else if (noti.supervisor._id) {
        userName = noti.supervisor.username;
    }
    
    return userName;
}

@end
