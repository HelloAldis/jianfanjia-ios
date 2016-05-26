//
//  Designer.m
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "Designer.h"

@implementation Designer

@dynamic _id;
@dynamic phone;
@dynamic username;
@dynamic realname;
@dynamic sex;
@dynamic province;
@dynamic city;
@dynamic district;
@dynamic address;
@dynamic imageid;
@dynamic email;
@dynamic view_count;
@dynamic authed_product_count;
@dynamic product_count;
@dynamic order_count;
@dynamic dec_types;
@dynamic dec_house_types;
@dynamic dec_districts;
@dynamic dec_styles;
@dynamic philosophy;
@dynamic achievement;
@dynamic company;
@dynamic team_count;
@dynamic design_fee_range;
@dynamic is_my_favorite;
@dynamic service_attitude;
@dynamic respond_speed;
@dynamic auth_type;
@dynamic uid_auth_type;
@dynamic match;
@dynamic tags;
@dynamic work_auth_type;
@dynamic email_auth_type;
@dynamic university;
@dynamic diploma_imageid;
@dynamic work_year;
@dynamic award_details;
@dynamic bank;
@dynamic bank_card;
@dynamic bank_card_image1;
@dynamic uid;
@dynamic uid_image1;
@dynamic uid_image2;

- (AwardDetail *)awardAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.award_details.count) {
        NSMutableDictionary *dict = [self.award_details objectAtIndex:index];
        return [[AwardDetail alloc] initWith:dict];
    } else {
        return nil;
    }
}

@end
