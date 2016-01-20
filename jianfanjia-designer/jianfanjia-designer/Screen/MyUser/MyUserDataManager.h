//
//  MyUserDataManager.h
//  jianfanjia-designer
//
//  Created by Karos on 16/1/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUserDataManager : NSObject

@property (nonatomic, strong) NSArray *unprocessActions;
@property (nonatomic, strong) NSArray *processingActions;
@property (nonatomic, strong) NSArray *processedActions;

- (void)refreshAllActions;

@end
