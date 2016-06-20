//
//  DesignerListViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface DiarySetDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (instancetype)initWithDiarySet:(DiarySet *)diarySet fromNewDiarySet:(BOOL)fromNewDiarySet;

@end
