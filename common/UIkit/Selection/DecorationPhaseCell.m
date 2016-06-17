//
//  DecorationStyleCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecorationPhaseCell.h"

@interface DecorationPhaseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation DecorationPhaseCell

- (void)initWithImage:(UIImage *)img title:(NSString *)title {
    self.imgView.image = img;
    self.lblTitle.text = title;
}

@end
