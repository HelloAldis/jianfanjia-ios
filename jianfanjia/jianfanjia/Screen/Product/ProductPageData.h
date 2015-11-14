//
//  ProductPageData.h
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductPageData : NSObject

//For product page
@property (strong, nonatomic) Product *product;

- (ProductPageData *)refresh;

@end
