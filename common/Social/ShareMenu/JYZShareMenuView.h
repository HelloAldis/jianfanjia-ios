//
//  DropdownMenuView.h
//  jianfanjia
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYZShareMenuView : UIView

+ (void)show:(UIViewController *)controller datasource:(NSArray *)datasoure block:(JYZShareMenuChooseItemBlock)block;

@end

