//
//  SendAddRequirement.m
//  jianfanjia
//
//  Created by Karos on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SendUpdateRequirement.h"

@interface SendUpdateRequirement ()

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *district;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *cell;
@property (strong, nonatomic) NSString *cell_phase;
@property (strong, nonatomic) NSString *cell_building;
@property (strong, nonatomic) NSString *cell_unit;
@property (strong, nonatomic) NSString *cell_detail_number;
@property (strong, nonatomic) NSString *house_type;
@property (strong, nonatomic) NSString *dec_type;
@property (strong, nonatomic) NSNumber *house_area;
@property (strong, nonatomic) NSString *dec_style;
@property (strong, nonatomic) NSString *work_type;
@property (strong, nonatomic) NSNumber *total_price;
@property (strong, nonatomic) NSString *prefer_sex;
@property (strong, nonatomic) NSString *family_description;
@property (strong, nonatomic) NSString *communication_type;

@end

@implementation SendUpdateRequirement

@dynamic _id;
@dynamic province;
@dynamic city;
@dynamic district;
@dynamic street;
@dynamic cell;
@dynamic cell_phase;
@dynamic cell_building;
@dynamic cell_unit;
@dynamic cell_detail_number;
@dynamic house_type;
@dynamic dec_type;
@dynamic house_area;
@dynamic dec_style;
@dynamic work_type;
@dynamic total_price;
@dynamic prefer_sex;
@dynamic family_description;

- (id)initWithRequirement:(Requirement *)requirement {
    if (self = [super init]) {
        [self merge:requirement];
    }
    
    return self;
}

@end
