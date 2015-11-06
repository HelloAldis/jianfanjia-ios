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


@end

@implementation DesignerDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithDesigner:(Designer *)designer {
    
}

@end
