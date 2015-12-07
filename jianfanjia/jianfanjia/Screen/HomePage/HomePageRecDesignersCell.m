//
//  HomePageRecDesignersCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HomePageRecDesignersCell.h"
#import "ViewControllerContainer.h"

@interface HomePageRecDesignersCell ()

@property (weak, nonatomic) IBOutlet UIImageView *designerImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView3;
@property (weak, nonatomic) IBOutlet UILabel *designerName1;
@property (weak, nonatomic) IBOutlet UILabel *designerName2;
@property (weak, nonatomic) IBOutlet UILabel *designerName3;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView3;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars1;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars2;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars3;

@property (strong, nonatomic) NSArray *designerImageViews;
@property (strong, nonatomic) NSArray *designerNames;
@property (strong, nonatomic) NSArray *designerVs;
@property (strong, nonatomic) NSArray *designerStars;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation HomePageRecDesignersCell

- (void)awakeFromNib {
    self.designerImageViews = @[self.designerImageView1, self.designerImageView2, self.designerImageView3];
    self.designerNames = @[self.designerName1, self.designerName2, self.designerName3];
    self.designerVs = @[self.vImageView1, self.vImageView2, self.vImageView3];
    self.designerStars = @[self.stars1, self.stars2, self.stars3];
    [self.designerImageView1 setCornerRadius:30];
    [self.designerImageView2 setCornerRadius:30];
    [self.designerImageView3 setCornerRadius:30];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.contentView addGestureRecognizer:self.tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithDesigners:(NSArray *)designers {
    UIImage *full = [UIImage imageNamed:@"star_middle"];
    UIImage *empty = [UIImage imageNamed:@"star_middle_empty"];
    for (int i = 0; i < designers.count; i++) {
        Designer *designer = [designers objectAtIndex:i];
        UIImageView *imageView = [self.designerImageViews objectAtIndex:i];
        [imageView setUserImageWithId:designer.imageid];
        UILabel *name = [self.designerNames objectAtIndex:i];
        name.text = designer.username;
        NSArray *stars = [self.designerStars objectAtIndex:i];
        double s = (designer.service_attitude.doubleValue + designer.respond_speed.doubleValue)/2;
        [DesignerBusiness setStars:stars withStar:s fullStar:full emptyStar:empty];
        UIImageView *v = [self.designerVs objectAtIndex:i];
        [DesignerBusiness setV:v withAuthType:designer.auth_type];
    }
}

- (void)onTap {
    [ViewControllerContainer showOrderDesigner:[DataManager shared].homePageRequirement];
}

@end
