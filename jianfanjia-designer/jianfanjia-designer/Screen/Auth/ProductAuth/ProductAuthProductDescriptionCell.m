//
//  ProductAuthProductDescriptionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthProductDescriptionCell.h"

#define kMaxProductDescLength 240

@interface ProductAuthProductDescriptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblLeftLength;

@end

@implementation ProductAuthProductDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
         self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxProductDescLength - value.length), @(kMaxProductDescLength)];
     }];
}

@end
