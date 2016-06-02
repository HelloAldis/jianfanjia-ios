//
//  IDCardVerifyUtil.h
//  jianfanjia-designer
//
//  Created by Karos on 16/6/2.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardVerifyUtil : NSObject

// 检查身份证合法性
+ (BOOL)isValidIDCardNumber:(NSString *)cardNumber;

// 检查银行卡合法性
+ (BOOL)isValidBankCardNumber:(NSString *)cardNumber;

@end
