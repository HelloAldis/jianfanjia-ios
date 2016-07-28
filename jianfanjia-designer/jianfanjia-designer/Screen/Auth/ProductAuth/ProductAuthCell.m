//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductAuthCell.h"
#import "ViewControllerContainer.h"

@interface ProductAuthCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblAuth;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) Product *product;
@property (nonatomic, copy) ProductAuthCellDeleteBlock deleteBlock;

@end

@implementation ProductAuthCell

- (void)awakeFromNib {
    [self.containerView setCornerRadius:3];
    [self.btnDelete setCornerRadius:self.btnDelete.frame.size.height / 2];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)initWithProduct:(Product *)product edit:(BOOL)edit deleteBlock:(ProductAuthCellDeleteBlock)deleteBlock {
    self.product = product;
    self.deleteBlock = deleteBlock;
    
    [self.productImageView setImageWithId:product.cover_imageid withWidth:kScreenWidth];
    self.lblCell.text = product.cell;
    self.lblDetail.text = product.house_area ? [NSString stringWithFormat:@"%@m², %@, %@, %@风格\n%@, %@万",
                                                product.house_area,
                                                [NameDict nameForDecType:product.dec_type],
                                                [ProductBusiness houseTypeByDecType:product],
                                                [NameDict nameForDecStyle:product.dec_style],
                                                [NameDict nameForWorkType:product.work_type],
                                                product.total_price] : @"";
    [self.lblDetail setRowSpace:7.0f];;
    self.lblAuth.text = [NameDict nameForProductAuthType:product.auth_type];
    self.authImageView.image = [ProductBusiness productAuthTypeImage:product.auth_type];
    
    if ([product.auth_type isEqualToString:kAuthTypeUnsubmitVerify]) {
        self.coverView.hidden = YES;
    } else {
        self.coverView.hidden = !edit;
    }
}

- (void)onTap {
    [ViewControllerContainer showProduct:self.product._id];
}

- (IBAction)onClickDelete:(id)sender {
    [AlertUtil show:[ViewControllerContainer getCurrentTopController] title:@"确定删除作品？" cancelBlock:^{
        
    } doneBlock:^{
        DesignerDeleteProduct *request = [[DesignerDeleteProduct alloc] init];
        request._id = self.product._id;
        
        [API designerDeleteProduct:request success:^{
            if (self.deleteBlock) {
                self.deleteBlock();
            }
        } failure:^{
        } networkError:^{
            
        }];
    }];
}

@end
