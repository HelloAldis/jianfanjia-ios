//
//  HomePageDataManager.h
//  jianfanjia
//
//  Created by Karos on 16/2/19.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageDataManager : NSObject

@property (nonatomic, strong) NSArray *homeProducts;

- (void)refresh;

@end
