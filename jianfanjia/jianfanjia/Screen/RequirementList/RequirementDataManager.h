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

- (void)refresh;

@end
