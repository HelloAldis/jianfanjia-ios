//
//  W4View.m
//  jianfanjia
//
//  Created by JYZ on 15/10/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "W4View.h"

@implementation W4View

+ (W4View *)w4View {
    return [[[NSBundle mainBundle] loadNibNamed:@"W4View" owner:nil options:nil] lastObject];
}

@end
