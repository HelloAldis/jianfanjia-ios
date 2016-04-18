//
//  W1View.m
//  jianfanjia
//
//  Created by JYZ on 15/10/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "W1View.h"

@implementation W1View

+ (W1View *)w1View {
    return [[[NSBundle mainBundle] loadNibNamed:@"W1View" owner:nil options:nil] lastObject];
}


@end
