//
//  MatchDesignerCell.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHorizontalImageCellWidth (kScreenWidth * 0.9)
#define kHorizontalImageCellHeight (kHorizontalImageCellWidth * 0.7)

@interface HorizontalImageCell : UITableViewCell

- (void)initWithImages:(NSArray *)images;

@end
