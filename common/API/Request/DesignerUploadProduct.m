//
//  SearchPrettyImage.m
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerUploadProduct.h"

@interface DesignerUploadProduct ()

//@property (strong, nonatomic) NSString *_id;
//@property (strong, nonatomic) NSString *province;
//@property (strong, nonatomic) NSString *city;
//@property (strong, nonatomic) NSString *district;
//@property (strong, nonatomic) NSString *street;
//@property (strong, nonatomic) NSString *house_type;
//@property (strong, nonatomic) NSString *dec_type;
//@property (strong, nonatomic) NSNumber *house_area;
//@property (strong, nonatomic) NSString *dec_style;
//@property (strong, nonatomic) NSString *work_type;
//@property (strong, nonatomic) NSNumber *total_price;
//@property (strong, nonatomic) NSString *cover_imageid;
//@property (strong, nonatomic) NSString *product_description;
//@property (strong, nonatomic) NSMutableArray *plan_images;
//@property (strong, nonatomic) NSMutableArray *images;

@end

@implementation DesignerUploadProduct

- (id)initWithProduct:(Product *)product {
    if (self = [super init]) {
        [self merge:product];
    }
    
    return self;
}

- (void)setObject:(id)o forKey:(NSString *)key {
    if ([@"product_description" isEqualToString:key]) {
        [[self data] setObject:o forKey:@"description"];
    } else {
        [[self data] setObject:o forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    if ([@"product_description" isEqualToString:key]) {
        return [[self data] objectForKey:@"description"];
    } else {
        return [[self data] objectForKey:key];
    }
}

@end
