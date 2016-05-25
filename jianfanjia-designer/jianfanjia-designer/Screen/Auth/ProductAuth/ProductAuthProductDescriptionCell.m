//
//  ProductAuthProductDescriptionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthProductDescriptionCell.h"

#define kMaxProductDescLength 140

@interface ProductAuthProductDescriptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblLeftLength;

@property (strong, nonatomic) Product *product;

@end

@implementation ProductAuthProductDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initWithProduct:(Product *)product {
    self.product = product;
    self.tvDesc.text = product.product_description;
    [self limitTextViewLength];
}

- (void)limitTextViewLength {
    @weakify(self);
    [[self.tvDesc.rac_textSignal
      length:^NSInteger{
          return kMaxProductDescLength;
      }]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         if ([value trim].length == 0) {
             self.tvDesc.text = [value trim];
             return;
         }
         
         self.tvDesc.text = value;
         self.product.product_description = value;
         self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxProductDescLength - value.length), @(kMaxProductDescLength)];
     }];
}

@end
