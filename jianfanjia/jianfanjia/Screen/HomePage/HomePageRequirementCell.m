//
//  HomePageRequirementCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HomePageRequirementCell.h"
#import "ViewControllerContainer.h"

@interface HomePageRequirementCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnRequirement;

@end

@implementation HomePageRequirementCell

- (void)awakeFromNib {
    [self.btnRequirement setCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClickRequirement:(id)sender {
    [ViewControllerContainer showRequirementCreate:nil];
}

@end
