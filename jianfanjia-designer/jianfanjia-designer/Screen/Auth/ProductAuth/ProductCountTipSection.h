//
//  ProductAuthImageHeaderView.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProductCountTipSectionHeight 50

@interface ProductCountTipSection : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

+ (ProductCountTipSection *)productCountTipSection;

@end
