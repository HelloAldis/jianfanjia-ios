//
//  DesignerBusiness.h
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comment;

@interface CommentBusiness : NSObject

+ (NSString *)imageId:(Comment *)comment;
+ (NSString *)userName:(Comment *)comment;

@end
