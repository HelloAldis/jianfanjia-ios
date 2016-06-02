//
//  IDCardVerifyUtil.h
//  jianfanjia-designer
//
//  Created by Karos on 16/6/2.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardVerifyUtil : NSObject

+ (BOOL)validateIDCardNumber:(NSString *)value;

@end
