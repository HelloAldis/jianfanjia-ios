//
//  DesignerBusiness.m
//  jianfanjia
//
//  Created by JYZ on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerBusiness.h"

@implementation DesignerBusiness

+ (void)setStars:(NSArray *)imageViewArray withStar:(double)star fullStar:(UIImage *)full emptyStar:(UIImage *)empty {
    int total = round(star);
    for (int i = 0; i < imageViewArray.count; i++) {
        UIImageView *imageView = [imageViewArray objectAtIndex:i];
        if (i < total) {
            imageView.image = full;
        } else {
            imageView.image = empty;
        }
    }
}

+ (void)setV:(UIImageView *)imageView withAuthType:(NSString *)authType {
    if ([kAuthTypeVerifyPass isEqualToString:authType]) {
        [imageView setImage:[UIImage imageNamed:@"v"]];
        imageView.hidden = NO;
    } else {
        imageView.hidden = YES;
    }
}

+ (NSInteger)setStars:(NSArray *)imageViewArray withTouchStar:(UIImageView *)touchedStar fullStar:(UIImage *)full emptyStar:(UIImage *)empty {
    __block NSInteger touchIndex = imageViewArray.count - 1;
    [imageViewArray enumerateObjectsUsingBlock:^(UIImageView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == touchedStar) {
            touchIndex = idx;
        }
        
        if (idx > touchIndex) {
            obj.image = empty;
        } else {
            obj.image = full;
        }
    }];
    
    return touchIndex + 1;
}

+ (void)displayStars:(NSArray *)imageViewArray withAmount:(NSInteger)amount fullStar:(UIImage *)full emptyStar:(UIImage *)empty {
    [imageViewArray enumerateObjectsUsingBlock:^(UIImageView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((idx + 1) <= amount) {
            obj.image = full;
        } else {
            obj.image = empty;
        }
    }];
}

@end
