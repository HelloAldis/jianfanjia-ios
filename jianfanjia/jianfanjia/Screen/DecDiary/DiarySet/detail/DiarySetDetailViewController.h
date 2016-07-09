//
//  DesignerListViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@class DiarySetDetailViewContainerController;

@interface DiarySetDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (instancetype)initWithDiarySet:(DiarySet *)diarySet;

- (NSString *)getMenuCurPhase;
- (NSArray *)getMenuNumberOfPhases;
- (void)didChooseMenuPhase:(NSString *)phase;

@end
