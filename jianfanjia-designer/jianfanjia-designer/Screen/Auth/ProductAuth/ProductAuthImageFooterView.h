//
//  ProductAuthImageHeaderView.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProductAuthImageFooterViewHeight 140

typedef void (^ProductAuthImageFooterViewTapBlock)(void);

@interface ProductAuthImageFooterView : UIView

@property (nonatomic, copy) ProductAuthImageFooterViewTapBlock tapBlock;

+ (ProductAuthImageFooterView *)productAuthImageFooterView;

@end
