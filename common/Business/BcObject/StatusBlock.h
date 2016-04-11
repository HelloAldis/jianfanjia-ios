//
//  StatusBlock.h
//  jianfanjia
//
//  Created by Karos on 16/4/8.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kElseStatus;

typedef void (^StatusBlockAction)(void);

@interface StatusBlock : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, copy) StatusBlockAction actionBlock;

+ (StatusBlock *)match:(NSString *)status action:(StatusBlockAction)actionBlock;

+ (void)matchReqt:(NSString *)status actions:(NSArray <StatusBlock *>*)actions;
+ (void)matchPlan:(NSString *)status actions:(NSArray <StatusBlock *>*)actions;
+ (void)matchReqt:(NSString *)status action:(StatusBlock *)action;
+ (void)matchPlan:(NSString *)status action:(StatusBlock *)action;

@end
