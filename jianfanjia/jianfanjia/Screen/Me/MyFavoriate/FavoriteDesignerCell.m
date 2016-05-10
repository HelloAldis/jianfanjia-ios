//
//  FavoriteDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriteDesignerCell.h"
#import "ViewControllerContainer.h"

@interface FavoriteDesignerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignerName;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;

@property (weak, nonatomic) Designer *designer;
@property (strong, nonatomic) UITapGestureRecognizer *tapDesignerImage;

@end

@implementation FavoriteDesignerCell

- (void)awakeFromNib {
    [self.tagView setCornerRadius:self.tagView.bounds.size.height / 2];
    [self.designerImageView setCornerRadius:30];
    self.tapDesignerImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDesignerImage)];
    [self.contentView addGestureRecognizer:self.tapDesignerImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    [self.designerImageView setUserImageWithId:self.designer.imageid];
    self.lblDesignerName.text = self.designer.username;
    self.tagView.bgColor = [DesignerBusiness designerTagColorByArr:self.designer.tags];
    self.lblTag.text = [DesignerBusiness designerTagTextByArr:self.designer.tags];
    
    double star = (self.designer.service_attitude.doubleValue + self.designer.respond_speed.doubleValue)/2;
    UIImage *full = [UIImage imageNamed:@"star_middle"];
    UIImage *empty = [UIImage imageNamed:@"star_middle_empty"];
    [DesignerBusiness setStars:self.stars withStar:star fullStar:full emptyStar:empty];
    [DesignerBusiness setV:self.authIcon withAuthType:designer.auth_type];
}

- (void)onTapDesignerImage {
    if (self.designer) {
        [ViewControllerContainer showDesigner:self.designer._id];
    }
}

@end
