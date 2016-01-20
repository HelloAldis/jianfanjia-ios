//
//  ProductPageData.m
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductPageData.h"

@implementation ProductPageData

- (ProductPageData *)refresh {
    NSMutableDictionary *dict = [DataManager shared].data;
    self.product = [[Product alloc] initWith:dict];
    self.product.designer = [[Designer alloc] initWith:[dict objectForKey:@"designer"]];
    
    return self;
}

@end
