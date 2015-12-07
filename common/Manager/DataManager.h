//
//  DataManager.h
//  jianfanjia
//
//  Created by JYZ on 15/9/6.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Requirement;
@class Product;
@class Designer;

@interface DataManager : NSObject

@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) id data;

//For signup page
@property (strong, nonatomic) NSString *signupPagePhone;
@property (strong, nonatomic) NSString *signupPagePass;

//For home page
@property (assign, nonatomic) BOOL homePageNeedRefresh;
@property (strong, nonatomic) Requirement *homePageRequirement;
@property (strong, nonatomic) NSMutableArray *homePageRequirementDesigners;
@property (strong, nonatomic) NSMutableArray *homePageDesigners;

//For uplpad image
@property (nonatomic, strong) NSString *lastUploadImageid;


kSynthesizeSingletonForHeader(DataManager)

@end

