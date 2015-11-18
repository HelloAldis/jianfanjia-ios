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

- (void)refreshRequirementList;
- (void)refreshOrderedDesigners:(Requirement *)requirement;
- (void)refreshOrderableDesigners;

@end
