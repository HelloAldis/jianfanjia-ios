//
//  Product.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@class ProductImage;
@class Designer;

@interface Product : BaseModel

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *designerid;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *district;
@property (strong, nonatomic) NSString *cell;
@property (strong, nonatomic) NSString *house_type;
@property (strong, nonatomic) NSString *dec_type;
@property (strong, nonatomic) NSNumber *house_area;
@property (strong, nonatomic) NSString *dec_style;
@property (strong, nonatomic) NSString *work_type;
@property (strong, nonatomic) NSString *auth_type;
@property (strong, nonatomic) NSNumber *total_price;
@property (strong, nonatomic) NSString *product_description;
@property (strong, nonatomic) NSString *cover_imageid;
@property (strong, nonatomic) NSMutableArray *plan_images;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSNumber *is_my_favorite;
@property (strong, nonatomic) NSNumber *is_deleted;


//不动态的属性
@property (strong, nonatomic) Designer *designer;

- (ProductImage *)planImageAtIndex:(NSInteger)index;
- (ProductImage *)imageAtIndex:(NSInteger)index;

@end

