//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ItemImageCollectionCell.h"

@interface ItemImageCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *maskBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblDeleteText;

@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) NSString *imageid;

@end

@implementation ItemImageCollectionCell

- (void)initWithImage:(NSString *)imageid width:(CGFloat)width {
    self.imageid = imageid;
    self.maskBackground.hidden = YES;
    self.lblDeleteText.hidden = YES;
    
    if (imageid) {
        [self.image setImageWithId:imageid withWidth:width];
    } else {
        self.image.image = [UIImage imageNamed:@"btn_add_image"];
    }
}

- (void)initWithImage:(UIImage *)image {
    self.maskBackground.hidden = YES;
    self.lblDeleteText.hidden = YES;
    
    self.image.image = image;
}

#pragma mark - Custom Methods

- (void)startShaking {
    if (self.isEditing == YES)
        return;
    // put item in editing mode
    self.isEditing = YES;
    
    if (self.imageid) {
        self.maskBackground.hidden = NO;
        self.lblDeleteText.hidden = NO;
    } else {
        self.maskBackground.hidden = YES;
        self.lblDeleteText.hidden = YES;
    }
    
    // start the wiggling animation
    CGFloat rotation = 0.03;
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
}

- (void)endShaking {
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    self.maskBackground.hidden = YES;
    self.lblDeleteText.hidden = YES;
    self.isEditing = NO;
}

@end
