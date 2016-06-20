//
//  ProductAuthImageHeaderView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AddDiarySectionView.h"

@interface AddDiarySectionView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconPlus;

@end

@implementation AddDiarySectionView

+ (AddDiarySectionView *)addDiarySectionView {
    AddDiarySectionView *view = [[NSBundle mainBundle] loadNibNamed:@"AddDiarySectionView" owner:nil options:nil].lastObject;
    view.iconPlus.tintColor = kThemeColor;
    return view;
}

@end
