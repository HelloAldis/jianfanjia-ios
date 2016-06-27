//
//  HomePageDesignerCell.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDecDiaryStatusCell.h"

@interface DecDiary1StatusCell : BaseDecDiaryStatusCell

- (void)initWithDiary:(Diary *)diary diarys:(NSMutableArray *)diarys tableView:(UITableView *)tableView hideTopLine:(BOOL)hideTopLine;

@end
