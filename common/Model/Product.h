//
//  Product.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"
#import "ProductImage.h"

@interface Product : BaseModel

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *district;
@property (strong, nonatomic) NSString *cell;
@property (strong, nonatomic) NSString *house_type;
@property (strong, nonatomic) NSString *dec_type;
@property (strong, nonatomic) NSNumber *house_area;
@property (strong, nonatomic) NSString *dec_style;
@property (strong, nonatomic) NSString *work_type;
@property (strong, nonatomic) NSNumber *total_price;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSMutableArray *images;

- (ProductImage *)imageAtIndex:(NSInteger )index;


@end

