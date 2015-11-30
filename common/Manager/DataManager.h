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
@property (strong, nonatomic) Requirement *homePageRequirement;
@property (strong, nonatomic) NSMutableArray *homePageRequirementDesigners;
@property (strong, nonatomic) NSMutableArray *homePageDesigners;

//For requirement page
@property (nonatomic, strong) NSString *requirementPageSelectedProvince;
@property (nonatomic, strong) NSString *requirementPageSelectedCity;
@property (nonatomic, strong) NSString *requirementPageSelectedArea;

@property (nonatomic, strong) NSString *requirementPageSelectedHouseType;
@property (nonatomic, strong) NSString *requirementPageSelectedDecorationType;
@property (nonatomic, strong) NSString *requirementPageSelectedPopulationType;
@property (nonatomic, strong) NSString *requirementPageSelectedDecorationStyle;
@property (nonatomic, strong) NSString *requirementPageSelectedWorkType;
@property (nonatomic, strong) NSString *requirementPageSelectedCommunicationType;
@property (nonatomic, strong) NSString *requirementPageSelectedSexType;


//For uplpad image
@property (nonatomic, strong) NSString *lastUploadImageid;


kSynthesizeSingletonForHeader(DataManager)

@end

