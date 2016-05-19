//
//  ItemImageCollectionCell.h
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTeamAuthCellHeight 244

typedef void (^TeamAuthCellDeleteBlock)(void);

@interface TeamAuthCell : UICollectionViewCell

- (void)initWithTeam:(Team *)team edit:(BOOL)edit deleteBlock:(TeamAuthCellDeleteBlock)deleteBlock;

@end


