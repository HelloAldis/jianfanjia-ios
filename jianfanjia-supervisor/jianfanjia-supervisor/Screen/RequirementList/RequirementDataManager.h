//
//  RequirementListData.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequirementDataManager : NSObject

@property (nonatomic, strong) NSArray *requirementPlans;
@property (nonatomic, strong) NSArray *planPriceItems;
@property (nonatomic, strong) NSMutableArray *comments;

- (void)refreshRequirementPlans;
- (void)refreshPlanPriceItems:(Plan *)plan;
- (void)refreshComments;
- (void)loadMoreComments;

@end
