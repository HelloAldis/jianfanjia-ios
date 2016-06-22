//
//  HomePageDesignerCell.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDecDiaryStatusCell.h"

typedef void (^DiaryStatusDeleteDoneBlock)(void);
typedef void (^DiaryStatusClickCommentBlock)(void);

@interface DecDiaryStatusAllCell : BaseDecDiaryStatusCell

@property (nonatomic, copy) DiaryStatusDeleteDoneBlock deleteDoneBlock;
@property (nonatomic, copy) DiaryStatusClickCommentBlock clickCommentBlock;

- (void)initWithDiary:(Diary *)diary diarys:(NSMutableArray *)diarys tableView:(UITableView *)tableView;

@end
