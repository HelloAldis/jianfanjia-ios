//
//  DropdownMenuView.h
//  jianfanjia
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DropdownChooseItemBlock)(id value);

@interface DropdownMenuView : UIView

@property (assign, nonatomic, readonly) BOOL isShowing;

- (void)show;
- (void)dismiss:(BOOL)animated;
- (void)refreshDatasource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue;

+ (DropdownMenuView *)show:(UIView *)view datasource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue block:(DropdownChooseItemBlock)block;


@end
