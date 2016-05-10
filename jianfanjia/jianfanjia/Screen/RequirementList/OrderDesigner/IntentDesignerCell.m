//
//  IntentDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "IntentDesignerCell.h"
#import "ViewControllerContainer.h"

@interface IntentDesignerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;

@end

@implementation IntentDesignerCell

- (void)awakeFromNib {
    [self.tagView setCornerRadius:self.tagView.bounds.size.height / 2];
    [self.imgAvatar setCornerRadius:self.imgAvatar.bounds.size.width / 2];
    [self.imgAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDesignerAvatar)]];
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
    self.tagView.bgColor = [DesignerBusiness designerTagColorByArr:self.designer.tags];
    self.lblTag.text = [DesignerBusiness designerTagTextByArr:self.designer.tags];
    
    [DesignerBusiness setV:self.authIcon withAuthType:designer.auth_type];
    [DesignerBusiness setStars:self.evaluatedStars withStar:(designer.respond_speed.floatValue +  designer.service_attitude.floatValue) / 2 fullStar:[UIImage imageNamed:@"star_small"] emptyStar:[UIImage imageNamed:@"star_small_empty"]];
}

- (void)onClickDesignerAvatar {
    [ViewControllerContainer showDesigner:self.designer._id];
}

@end
