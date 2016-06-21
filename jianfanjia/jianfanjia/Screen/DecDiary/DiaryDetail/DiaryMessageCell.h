//
//  MatchDesignerCell.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDiaryMessagePrefix @"回复"
#define kDiaryMessageSubfix @"："

@interface DiaryMessageCell : UITableViewCell

- (void)initWithComment:(Comment *)comment;

@end
