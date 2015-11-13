//
//  DesignerDetailCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerDetailCell.h"

@interface DesignerDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblDecTypes;
@property (weak, nonatomic) IBOutlet UILabel *lblDecHouseTypes;
@property (weak, nonatomic) IBOutlet UILabel *lblDecDistricts;
@property (weak, nonatomic) IBOutlet UILabel *lblDecStyles;
@property (weak, nonatomic) IBOutlet UILabel *lblPhilosophy;
@property (weak, nonatomic) IBOutlet UILabel *lblAchievement;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblTeamCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignFee;

@property (weak, nonatomic) Designer *designer;

@end

@implementation DesignerDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    
    self.lblDecTypes.text = [[self.designer.dec_types map:^(NSString *dec_type){
        return [NameDict nameForDecType:dec_type];
    }] join:@" "];
    self.lblDecHouseTypes.text = [[self.designer.dec_house_types map:^(NSString *house_type) {
        return [NameDict nameForHouseType:house_type];
    }] join:@" "];
    self.lblDecDistricts.text = [self.designer.dec_districts join:@" "];
    self.lblDecStyles.text = [[self.designer.dec_styles map:^(NSString *style) {
        return [NameDict nameForDecStyle:style];
    }] join:@" "];
    self.lblPhilosophy.text = self.designer.philosophy;
    self.lblAchievement.text = self.designer.achievement;
    self.lblCompany.text = self.designer.company;
    self.lblTeamCount.text = [self.designer.team_count stringValue];
    self.lblDesignFee.text = [NameDict nameForDesignerFee:self.designer.design_fee_range];
}

@end
