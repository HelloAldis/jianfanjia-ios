//
//  DropdownMenuView.h
//  jianfanjia
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectionMenuChooseItemBlock)(id value);

@interface SelectionMenuView : UIView

+ (void)show:(UIViewController *)controller datasource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue block:(SelectionMenuChooseItemBlock)block;

@end

