//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HomePageDesignerCell.h"
#import "ViewControllerContainer.h"

@interface HomePageDesignerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (weak, nonatomic) Designer *designer;
@property (strong, nonatomic) UITapGestureRecognizer *tapProductImage;
@property (strong, nonatomic) UITapGestureRecognizer *tapDesignerImage;

@end

@implementation HomePageDesignerCell

- (void)awakeFromNib {
    // Initialization code
    [self.designerImageView setCornerRadius:30];
    [self.designerImageView setBorder:1 andColor:[[UIColor whiteColor] CGColor]];

    self.tapDesignerImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDesignerImage:)];
    [self.designerImageView addGestureRecognizer:self.tapDesignerImage];
    self.tapProductImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProductImage:)];
    [self.productImageView addGestureRecognizer:self.tapProductImage];
}

- (void)initWith:(Designer *)designer {
    self.designer = designer;
    
    ProductImage *productImage = [designer.product imageAtIndex:0];
    [self.productImageView setImageWithId:productImage.imageid withWidth:kScreenWidth];
    [self.designerImageView setUserImageWithId:self.designer.imageid];
    self.lblCell.text = self.designer.product.cell;
    self.lblDetail.text = [NSString stringWithFormat:@"%@m², %@, %@风格",
                           self.designer.product.house_area,
                           [NameDict nameForHouseType:self.designer.product.house_type],
                           [NameDict nameForDecStyle:self.designer.product.dec_style]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onTapProductImage:(UIGestureRecognizer *)sender {
    if (self.designer) {
        [ViewControllerContainer showProduct:self.designer.product._id];
    }
}

- (void)onTapDesignerImage:(UIGestureRecognizer *)sender {
    if (self.designer) {
        [ViewControllerContainer showDesigner:self.designer._id];
    }
}

@end
