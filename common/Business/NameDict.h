//
//  NameDict.h
//  jianfanjia
//
//  Created by JYZ on 15/10/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameDict : NSObject

+ (NSString *)nameForHouseType:(NSString *)type;
+ (NSString *)nameForDecStyle:(NSString *)style;
+ (NSString *)nameForDecType:(NSString *)type;
+ (NSString *)nameForDesignerFee:(NSString *)design_fee;

@end
