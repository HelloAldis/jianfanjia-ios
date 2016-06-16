//
//  DesignerListDataManager.h
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiarySetDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *diarySets;

- (NSInteger)refresh;
- (NSInteger)loadMore;

@end
