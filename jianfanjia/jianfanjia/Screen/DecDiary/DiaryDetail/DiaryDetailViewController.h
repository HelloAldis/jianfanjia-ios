//
//  DesignerListViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface DiaryDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (instancetype)initWithDiary:(Diary *)diary showComment:(BOOL)showComment;

@end
