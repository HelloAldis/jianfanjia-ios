//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthImpressionImageCell.h"

#define kMaxProductImpressoinImageDescLength 120

@interface ProductAuthImpressionImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblSelection;
@property (weak, nonatomic) IBOutlet UITextView *tvDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftLength;

@end

@implementation ProductAuthImpressionImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView setCornerRadius:5];
    [self.imgView setBorder:0.5 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.bottomView setCornerRadius:5];
    [self.bottomView setBorder:0.5 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.selectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSelection)]];
}

- (void)initWithProduct:(Product *)product image:(ProductImage *)image {
    [self.imgView setImageWithId:image.imageid withWidth:kScreenWidth];
    self.tvDesc.text = image.productImage_description;
    self.lblSelection.text = image.section;
    self.coverImgView.hidden = ![product.cover_imageid isEqualToString:image.imageid];
    [self limitTextViewLength];
}

- (void)limitTextViewLength {
    @weakify(self);
    [[self.tvDesc.rac_textSignal
      length:^NSInteger{
          return kMaxProductImpressoinImageDescLength;
      }]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         if ([value trim].length == 0) {
             self.tvDesc.text = [value trim];
             return;
         }
         
         self.tvDesc.text = value;
         self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxProductImpressoinImageDescLength - value.length), @(kMaxProductImpressoinImageDescLength)];
     }];
}

- (void)onTapSelection {
    
}

@end
