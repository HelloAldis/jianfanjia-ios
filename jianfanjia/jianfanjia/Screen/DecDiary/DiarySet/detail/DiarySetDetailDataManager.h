//
//  DesignerListDataManager.h
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiarySetDetailDataManager : NSObject

@property (nonatomic, strong) DiarySet *diarySet;
@property (nonatomic, strong) NSMutableArray *diarys;
@property (nonatomic, strong) NSMutableArray *menuNumberOfPhases;

- (NSInteger)refresh;

@end
