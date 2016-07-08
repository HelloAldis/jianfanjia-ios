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

@property (nonatomic, weak) DiarySetDetailViewContainerController *containerController;

- (instancetype)initWithDiarySet:(DiarySet *)diarySet;

@end
