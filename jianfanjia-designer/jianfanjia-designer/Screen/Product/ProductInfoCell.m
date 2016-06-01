//
//  ProductInfoCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductInfoCell.h"
#import "ViewControllerContainer.h"

@interface ProductInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;

@property (weak, nonatomic) Product *product;
@property (strong, nonatomic) UITapGestureRecognizer *tapDesigner;

@end

@implementation ProductInfoCell

- (void)awakeFromNib {
    // Initialization code
    [self.designerImageView setCornerRadius:30];
    self.tapDesigner = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDesigner)];
    [self.designerImageView addGestureRecognizer:self.tapDesigner];
}

- (void)initWithProduct:(Product *)product {
    self.product = product;
    
    self.lblCell.text = product.cell;
    self.lblDetail.text = [NSString stringWithFormat:@"%@m², %@, %@, %@风格\n%@ %@",
                           product.house_area,
                           [NameDict nameForDecType:product.dec_type],
                           [NameDict nameForHouseType:product.house_type],
                           [NameDict nameForDecStyle:product.dec_style],
                           [NameDict nameForWorkType:product.work_type],
                           product.total_price
                           ];
    [self.lblDetail setRowSpace:7.0f];
    [self.designerImageView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    self.lblDescription.text = self.product.product_description;
    [self.lblDescription setRowSpace:10.0f];
    [DesignerBusiness setV:self.vImageView withAuthType:product.designer.auth_type];
}

#pragma mark - user action
- (void)onTapDesigner {
//    [ViewControllerContainer showDesigner:self.product.designer._id];
}

@end
