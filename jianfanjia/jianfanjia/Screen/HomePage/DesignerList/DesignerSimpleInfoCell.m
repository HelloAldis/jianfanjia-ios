//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerSimpleInfoCell.h"
#import "ViewControllerContainer.h"

@interface DesignerSimpleInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignerName;
@property (weak, nonatomic) IBOutlet UIImageView *imgIdCardChecked;
@property (weak, nonatomic) IBOutlet UIImageView *imgBaseInfoChecked;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;
@property (weak, nonatomic) IBOutlet UILabel *lblHouseTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleVal;

@property (weak, nonatomic) IBOutlet UILabel *lblProductCountVal;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderedCountVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignFeeVal;

@property (strong, nonatomic) Designer *designer;

@end

@implementation DesignerSimpleInfoCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:self.imgAvatar.bounds.size.width / 2];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCell)]];
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    [self.imgAvatar setImageWithId:designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblDesignerName.text = designer.username;
    self.lblHouseTypeVal.text = [[designer.dec_house_types map:^id(id obj) {
        return [NameDict nameForHouseType:obj];
    }] join:@"   "];
    self.lblStyleVal.text = [[designer.dec_styles map:^id(id obj) {
        return [NameDict nameForDecStyle:obj];
    }] join:@"   "];
    
    self.lblProductCountVal.text = [designer.authed_product_count stringValue];
    self.lblOrderedCountVal.text = [designer.order_count stringValue];
    self.lblDesignFeeVal.text = [NameDict nameForDesignerFee:designer.design_fee_range];
    
    [DesignerBusiness setIdCardCheck:self.imgIdCardChecked withAuthType:designer.uid_auth_type];
    [DesignerBusiness setBaseInfoCheck:self.imgBaseInfoChecked withAuthType:designer.auth_type];
    [DesignerBusiness setStars:self.evaluatedStars withStar:(designer.respond_speed.floatValue +  designer.service_attitude.floatValue) / 2 fullStar:[UIImage imageNamed:@"star_small"] emptyStar:[UIImage imageNamed:@"star_small_empty"]];
}

#pragma mark - gesture
- (void)onTapCell {
    [ViewControllerContainer showDesigner:self.designer._id];
}

@end
