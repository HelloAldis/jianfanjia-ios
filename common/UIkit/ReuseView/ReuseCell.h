//
//  ReuseCell.h
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReuseCell : UIView

@property (assign, nonatomic) NSInteger page;

- (void)reloadData;

@end
