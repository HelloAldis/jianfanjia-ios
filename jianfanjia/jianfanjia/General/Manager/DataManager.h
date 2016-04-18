//
//  DataManager.h
//  jianfanjia
//
//  Created by JYZ on 15/9/6.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) id data;

//For signup page
@property (strong, nonatomic) NSString *signupPagePhone;
@property (strong, nonatomic) NSString *signupPagePass;

//For uplpad image
@property (nonatomic, strong) NSString *lastUploadImageid;

//For collect requirement
@property (nonatomic, strong) NSString *collectedDecPhase;
@property (nonatomic, strong) NSArray *collectedDecStyle;
@property (nonatomic, strong) NSString *collectedFamilyInfo;

//For Wechat
@property (nonatomic, assign) BOOL isWechatFirstLogin;

kSynthesizeSingletonForHeader(DataManager)

@end

