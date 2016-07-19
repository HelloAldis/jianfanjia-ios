//
//  HomePageDesignerCell.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDecDiaryStatusCell.h"

// top line(6.0) header(85.0) toolbar(45.0)
#define DecDiaryStatusAllCellFixHeight 6.0 + 85.0 + 45.0

typedef void (^DiaryStatusDeleteDoneBlock)(void);
typedef void (^DiaryStatusClickCommentBlock)(void);

@interface DecDiaryStatusAllCell : BaseDecDiaryStatusCell

@property (nonatomic, copy) DiaryStatusDeleteDoneBlock deleteDoneBlock;
@property (nonatomic, copy) DiaryStatusClickCommentBlock clickCommentBlock;

- (void)initWithDiary:(Diary *)diary diarys:(NSMutableArray *)diarys tableView:(UITableView *)tableView;

@end
