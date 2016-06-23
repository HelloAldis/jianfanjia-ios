//
//  DesignerListViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^DiaryDetailDeleteDoneBlock)(void);

@interface DiaryDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (copy, nonatomic) DiaryDetailDeleteDoneBlock deleteDoneBlock;

- (instancetype)initWithDiary:(Diary *)diary showComment:(BOOL)showComment toUser:(User *)toUser;

@end
