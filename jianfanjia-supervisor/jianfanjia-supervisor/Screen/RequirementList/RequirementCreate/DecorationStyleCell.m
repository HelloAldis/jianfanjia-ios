//
//  DecorationStyleCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecorationStyleCell.h"

@interface DecorationStyleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation DecorationStyleCell

- (void)initWithImage:(UIImage *)img {
    self.imgView.image = img;
//    self.lblTitle.text = title;
}

@end
