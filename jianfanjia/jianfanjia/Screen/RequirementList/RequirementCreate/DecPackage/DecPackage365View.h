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

@property (strong, nonatomic) Requirement *requirement;
@property (copy, nonatomic) void(^refreshBlock)(void);

- (void)updateData:(Requirement *)requirement;

@end
