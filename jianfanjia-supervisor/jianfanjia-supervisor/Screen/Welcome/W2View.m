//
//  W2View.m
//  jianfanjia
//
//  Created by JYZ on 15/10/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "W2View.h"

@implementation W2View

+ (W2View *)w2View {
    return [[[NSBundle mainBundle] loadNibNamed:@"W2View" owner:nil options:nil] lastObject];
}


@end
