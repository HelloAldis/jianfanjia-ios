//
//  ProductHomePage.m
//  jianfanjia
//
//  Created by JYZ on 15/10/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductHomePage.h"

@implementation ProductHomePage

@dynamic _id;

- (void)pre {
    [DataManager shared].productPageProduct = nil;
}

- (void)success {
    NSMutableDictionary *dict = [DataManager shared].data;
    [DataManager shared].productPageProduct = [[Product alloc] initWith:dict];
    [DataManager shared].productPageProduct.designer = [[Designer alloc] initWith:[dict objectForKey:@"designer"]];
}

@end
