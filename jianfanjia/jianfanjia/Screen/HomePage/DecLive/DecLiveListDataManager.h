//
//  DesignerListDataManager.h
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecLiveListDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *declives;
@property (nonatomic, strong) NSMutableArray *ongoingDeclives;
@property (nonatomic, strong) NSMutableArray *finishDeclives;

- (NSInteger)refreshOngoingDeclives;
- (NSInteger)loadMoreOngoingDeclives;
- (NSInteger)refreshFinishDeclives;
- (NSInteger)loadMoreFinishDeclives;

@end
