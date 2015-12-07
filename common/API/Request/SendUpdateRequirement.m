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
        self._id = requirement._id;
        self.province = requirement.province;
        self.city = requirement.city;
        self.district = requirement.district;
        self.street = requirement.street;
        self.cell = requirement.cell;
        self.cell_phase = requirement.cell_phase;
        self.cell_building = requirement.cell_building;
        self.cell_unit = requirement.cell_unit;
        self.cell_detail_number = requirement.cell_detail_number;
        self.house_type = requirement.house_type;
        self.dec_type = requirement.dec_type;
        self.house_area = requirement.house_area;
        self.dec_style = requirement.dec_style;
        self.work_type = requirement.work_type;
        self.total_price = requirement.total_price;
        self.prefer_sex = requirement.prefer_sex;
        self.family_description = requirement.family_description;
    }
    
    return self;
}

@end
