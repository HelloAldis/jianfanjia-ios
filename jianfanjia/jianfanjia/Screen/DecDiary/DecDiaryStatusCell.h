//
//  HomePageDesignerCell.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecDiaryStatusCell : UITableViewCell

- (void)initWithDiary:(Diary *)diary truncate:(BOOL)needTruncate;

@end