//
//  HomePageDesignerCell.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat kDiarySetCellHeight;

typedef void (^DiarySetCellDeleteBlock)(void);

@interface DiarySetCell : UITableViewCell

- (void)initWithDiarySet:(DiarySet *)diarySet edit:(BOOL)edit deleteBlock:(DiarySetCellDeleteBlock)deleteBlock;

@end
