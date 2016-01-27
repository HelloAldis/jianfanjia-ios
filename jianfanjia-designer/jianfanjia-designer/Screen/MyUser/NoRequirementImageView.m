//
//  NoRequirementImageView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/1/27.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "NoRequirementImageView.h"

@implementation NoRequirementImageView

+ (NoRequirementImageView *)noRequirementImageView {
    return [[[NSBundle mainBundle] loadNibNamed:@"NoRequirementImageView" owner:nil options:nil] lastObject];
}

@end
