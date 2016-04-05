//
//  SectionView.h
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessDataManager.h"

extern CGFloat const kDecPackage365ViewHeight;

@interface DecPackage365View : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnDBYS;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeDate;
@property (weak, nonatomic) IBOutlet UIButton *btnUnresolvedChangeDate;
@property (weak, nonatomic) IBOutlet UIView *expandView;
@property (weak, nonatomic) IBOutlet UIImageView *expandIcon;

@property (weak, nonatomic) ProcessDataManager *dataManager;
@property (weak, nonatomic) Item *item;
@property (copy, nonatomic) void(^refreshBlock)(void);

- (void)updateData:(Item *)item withMgr:(ProcessDataManager *)dataManager refresh:(void(^)(void))refreshBlock;

@end
