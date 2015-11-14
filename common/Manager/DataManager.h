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

//For home page
@property (strong, nonatomic) Requirement *homePageRequirement;
@property (strong, nonatomic) NSMutableArray *homePageRequirementDesigners;
@property (strong, nonatomic) NSMutableArray *homePageDesigners;

//For requirement page
@property (nonatomic, strong) NSString *selectedProvince;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedArea;

kSynthesizeSingletonForHeader(DataManager)

@end

