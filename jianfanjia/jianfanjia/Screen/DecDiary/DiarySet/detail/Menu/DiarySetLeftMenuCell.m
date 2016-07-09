//
//  DecorationStyleCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetLeftMenuCell.h"

@interface DiarySetLeftMenuCell ()

@end

@implementation DiarySetLeftMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect frame = self.lineImgView.frame;
    frame.size.width = 0.5;
    self.lineImgView.frame = frame;
    self.lineImgView.image = [self.lineImgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0) resizingMode:UIImageResizingModeStretch];
    self.lineImgView.tintColor = kUntriggeredColor;
    self.circleImgView.tintColor = kThemeTextColor;
    self.lblPhase.textColor = kThemeTextColor;
}

@end
