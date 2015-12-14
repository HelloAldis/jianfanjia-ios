//
//  DesignerPageData.h
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignerPageData : NSObject

//For designer page
@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) NSMutableArray *products;

- (DesignerPageData *)refreshDesigner;
- (NSInteger)refreshProduct;
- (NSInteger)loadMoreProduct;

@end
