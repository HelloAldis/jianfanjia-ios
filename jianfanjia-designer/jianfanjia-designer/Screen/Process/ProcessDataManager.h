//
//  ProcessDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *processList;
@property (nonatomic, strong) Process *process;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, assign) NSInteger ongoingSectionIndex;
@property (nonatomic, strong) Section *selectedSection;
@property (nonatomic, assign) NSInteger selectedSectionIndex;
@property (nonatomic, strong) NSArray *selectedItems;

- (void)refreshProcessList;
- (void)refreshProcess;
- (void)refreshSections:(Process *)process;
- (void)switchToSelectedSection:(NSInteger)index;

@end
