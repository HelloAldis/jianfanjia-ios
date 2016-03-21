//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecLiveCell.h"
#import "ViewControllerContainer.h"
#import "WebViewController.h"

CGFloat kDecLiveCellHeight;

@interface DecLiveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblSection;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIView *boderView;
@property (weak, nonatomic) IBOutlet UILabel *lblLiveTime;

@property (strong, nonatomic) DecLive *declive;
@property (strong, nonatomic) UITapGestureRecognizer *tapProductImage;
@property (strong, nonatomic) UITapGestureRecognizer *tapDesignerImage;

@end

@implementation DecLiveCell

+ (void)initialize {
    if ([self class] == [DecLiveCell class]) {
        CGFloat aspect =  414 / kScreenWidth;
        kDecLiveCellHeight = round(190 / aspect);
    }
}

- (void)awakeFromNib {
    [self.designerImageView setCornerRadius:self.designerImageView.frame.size.width / 2];
    [self.boderView setCornerRadius:self.boderView.frame.size.width / 2];

    self.tapDesignerImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDesignerImage:)];
    [self.designerImageView addGestureRecognizer:self.tapDesignerImage];
    self.tapProductImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProductImage:)];
    [self.productImageView addGestureRecognizer:self.tapProductImage];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, kDecLiveCellHeight * 0.5, kScreenWidth, kDecLiveCellHeight * 0.5);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithR:0x00 g:0x00 b:0x00 a:0.5] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    gradient.startPoint = CGPointMake(0.5, 1.0);
    gradient.endPoint = CGPointMake(0.5, 0.0);
    gradient.locations = @[@0.5, @1.0];
    [self.productImageView.layer addSublayer:gradient];
}

- (void)initWithDecLive:(DecLive *)declive {
    self.declive = declive;
    
    [self.designerImageView setUserImageWithId:declive.designer.imageid];
    [self.productImageView setImageWithId:declive.cover_imageid withWidth:kScreenWidth];
    [DesignerBusiness setV:self.vImageView withAuthType:declive.designer.auth_type];

    self.lblSection.text = [NameDict nameForDecLiveSectionType:declive.curSection.name];
    self.lblCell.text = declive.cell;
    self.lblDetail.text = [NSString stringWithFormat:@"%@m² %@ %@ %@ %@",
                           declive.house_area,
                           [NameDict nameForHouseType:declive.house_type],
                           [NameDict nameForDecStyle:declive.dec_style],
                           [NameDict nameForDecType:declive.dec_type],
                           [NameDict nameForWorkType:declive.work_type]];
    self.lblLiveTime.text = [NSString stringWithFormat:@"直播时间：%@", [NSDate yyyy_MM_dd:declive.create_at]];
    
    if ([declive.progress isEqualToString:@"1"]) {
        self.sectionView.backgroundColor = kPassStatusColor;
    } else {
        self.sectionView.backgroundColor = kThemeColor;
    }
}

- (void)onTapProductImage:(UIGestureRecognizer *)sender {
    [WebViewController show:[ViewControllerContainer getCurrentTapController] withUrl:[NSString stringWithFormat:@"view/share/process.html?pid=%@", self.declive._id] shareTopic:ShareTopicDecLive];
}

- (void)onTapDesignerImage:(UIGestureRecognizer *)sender {
    [ViewControllerContainer showDesigner:self.declive.designerid];
}

@end
