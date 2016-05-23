//
//  ProductAuthImageHeaderView.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProductAuthImageHeaderViewHeight 36

@interface ProductAuthImageHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

+ (ProductAuthImageHeaderView *)productAuthImageHeaderView;

@end
