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
#define DecDiaryStatusCellFixHeight 6.0 + 85.0 + 45.0

@interface DecDiaryStatusCell : BaseDecDiaryStatusCell

- (void)initWithDiary:(Diary *)diary diarys:(NSMutableArray *)diarys tableView:(UITableView *)tableView;

@end
