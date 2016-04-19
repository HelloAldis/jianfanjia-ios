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

@end
