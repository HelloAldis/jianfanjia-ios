//
//  FavoriateProductCell.m
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriateProductCell.h"
#import "ViewControllerContainer.h"

@interface FavoriateProductCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *trashImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDeleteMessage;

@property (weak, nonatomic) Product *product;
@property (weak, nonatomic) DeleteFavoriateProductBlock block;

@end


@implementation FavoriateProductCell

- (void)awakeFromNib {
    [self.containerView setCornerRadius:4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDelete)];
    [self.coverView addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDetail)];
    [self.productImageView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithProduct:(Product *)product andDeleteFavoriateBlock:(DeleteFavoriateProductBlock)block {
    self.product = product;
    self.block = block;
    
    if ([self.product.is_deleted boolValue]) {
        self.coverView.hidden = NO;
        self.trashImageView.hidden = NO;
        self.lblDeleteMessage.hidden = NO;
        [self.productImageView setImage:[UIImage imageNamed:@"image_place_holder"]];
        self.lblDetail.text = @"原内容已被作者删除";
        self.lblCell.text = @"";
    } else {
        self.coverView.hidden = YES;
        self.trashImageView.hidden = YES;
        self.lblDeleteMessage.hidden = YES;
        self.lblCell.text = self.product.cell;
        [self.productImageView setImageWithId:product.cover_imageid withWidth:kScreenWidth];
        self.lblDetail.text = [NSString stringWithFormat:@"%@m², %@, %@风格",
                               self.product.house_area,
                               [ProductBusiness houseTypeByDecType:product],
                               [NameDict nameForDecStyle:self.product.dec_style]];
    }
}

- (void)onTapDelete {
    DeleteFavoriateProduct *request = [[DeleteFavoriateProduct alloc] init];
    request._id = [self.product _id];
    
    @weakify(self);
    [API deleteFavoriateProduct:request success:^{
        @strongify(self);
        self.block(self);
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)onTapDetail {
    [ViewControllerContainer showProduct:self.product._id];
}


@end
