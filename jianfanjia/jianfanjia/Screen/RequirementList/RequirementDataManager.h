//
//  RequirementListData.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequirementDataManager : NSObject

@property (nonatomic, strong) NSArray *requirements;
@property (nonatomic, strong) NSArray *orderedDesigners;
@property (nonatomic, strong) NSArray *recommendedDesigners;
@property (nonatomic, strong) NSArray *favoriteDesigners;
@property (nonatomic, strong) NSArray *requirementPlans;
@property (nonatomic, strong) NSArray *planPriceItems;

- (void)refreshRequirementList;
- (void)refreshOrderedDesigners:(Requirement *)requirement;
- (void)refreshOrderedDesigners;
- (void)refreshOrderableDesigners;
- (void)refreshRequirementPlans;
- (void)refreshPlanPriceItems:(Plan *)plan;

@end
