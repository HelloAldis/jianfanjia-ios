//
//  W2View.m
//  jianfanjia
//
//  Created by JYZ on 15/10/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "W3View.h"

@implementation W3View

+ (W3View *)w3View {
    return [[[NSBundle mainBundle] loadNibNamed:@"W3View" owner:nil options:nil] lastObject];
}

@end
