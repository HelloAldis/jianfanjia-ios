//
//  MatchDesignerCell.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryDetailDataManager.h"

@class DiaryMessageTableCell;

typedef void (^DiaryMessageTableCellDidSelectRowBlock)(Comment *comment, DiaryMessageTableCell *cell);

@interface DiaryMessageTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet EventTableView *tableView;
@property (strong, nonatomic) DiaryDetailDataManager *dataManager;
@property (copy, nonatomic) DiaryMessageTableCellDidSelectRowBlock didSelectRowBlock;

- (void)initWithDiary:(Diary *)diary superTableView:(UITableView *)superTableView diarySize:(CGSize)diarySize;
- (void)refreshMessageList:(BOOL)showPlsWait;

@end
