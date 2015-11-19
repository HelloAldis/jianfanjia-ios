//
//  IntentDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "IntentDesignerCell.h"

@interface IntentDesignerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;

@end

@implementation IntentDesignerCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:30];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.imgCheck.image = [UIImage imageNamed:@"checked"];
    } else {
        self.imgCheck.image = [UIImage imageNamed:@"unchecked"];
    }
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    [self.imgAvatar setImageWithId:designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = designer.username;
    [DesignerBusiness setV:self.authIcon withAuthType:designer.auth_Type];
    [DesignerBusiness setStars:self.stars withStar:(double)(designer.respond_speed.doubleValue + designer.service_attitude.doubleValue) / 2 fullStar:[UIImage imageNamed:@"star_middle"] emptyStar:[UIImage imageNamed:@"star_middle_empty"]];
}

@end
