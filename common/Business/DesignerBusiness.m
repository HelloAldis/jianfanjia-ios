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

+ (void)setIdCardCheck:(UIImageView *)imageView withAuthType:(NSString *)authType {
    UIImage *img = [UIImage imageNamed:@"icon_id_card_checked"];
    [imageView setImage:img];
    if ([kAuthTypeVerifyPass isEqualToString:authType]) {
        imageView.tintColor = [UIColor colorWithR:0x00 g:0xBF b:0x42];
    } else {
        imageView.tintColor = kUntriggeredColor;
    }
}

+ (void)setBaseInfoCheck:(UIImageView *)imageView withAuthType:(NSString *)authType {
    UIImage *img = [UIImage imageNamed:@"icon_base_info_checked"];
    [imageView setImage:img];
    if ([kAuthTypeVerifyPass isEqualToString:authType]) {
        imageView.tintColor = [UIColor colorWithR:0x00 g:0xBF b:0x42];
    } else {
        imageView.tintColor = kUntriggeredColor;
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

+ (void)setAvatarHangings:(UIImageView *)imageView withTags:(NSArray *)tags {
    if ([self containsJiangXinDingZhiTag:tags]) {
        [imageView setImage:[UIImage imageNamed:@"icon_crown"]];
        imageView.hidden = NO;
    } else {
        imageView.hidden = YES;
    }
}

+ (NSString *)designerTagTextByArr:(NSArray *)tags {
    if (tags && tags.count > 0) {
        return tags[0];
    }
    
    return nil;
}

+ (UIColor *)designerTagColorByArr:(NSArray *)tags {
    if (tags && tags.count > 0) {
        return [self designerTagColor:tags[0]];
    }
    
    return nil;
}

+ (UIColor *)designerTagColor:(NSString *)tag {
    UIColor *color = nil;
    if ([tag isEqualToString:kDesignerTagJiangXinDingZhi]) {
        color = [UIColor colorWithR:0xFF g:0x6F b:0x27];
    } else if ([tag isEqualToString:kDesignerTagXinYueXianFeng]) {
        color = [UIColor colorWithR:0x64 g:0xC5 b:0xF4];
    } else if ([tag isEqualToString:kDesignerTagNuanNuanZouXin]) {
        color = [UIColor colorWithR:0xFF g:0x73 b:0x78];
    } else {
        color = [UIColor clearColor];
    }
    
    return color;
}

+ (BOOL)containsJiangXinDingZhiTag:(NSArray *)tags {
    if (tags && tags.count > 0) {
        return [tags[0] isEqualToString:kDesignerTagJiangXinDingZhi];
    }
    
    return NO;
}

+ (UIColor *)authTypeColor:(NSString *)authType {
    UIColor *color = nil;
    if ([authType isEqualToString:kAuthTypeUnsubmitVerify]) {
        color = kExcutionStatusColor;;
    } else if ([authType isEqualToString:kAuthTypeSubmitedVerifyButNotPass]) {
        color = kExcutionStatusColor;;
    } else if ([authType isEqualToString:kAuthTypeVerifyPass]) {
        color = kPassStatusColor;;
    } else if ([authType isEqualToString:kAuthTypeVerifyNotPass]) {
        color = kReminderColor;
    } else {
        color = kReminderColor;
    }

    return color;
}

+ (CGFloat)getDesignerAuthProgress {
    NSString *basicAuthType = [GVUserDefaults standardUserDefaults].auth_type;
    NSString *teamAuthType = [GVUserDefaults standardUserDefaults].work_auth_type;
    NSString *uidAuthType = [GVUserDefaults standardUserDefaults].uid_auth_type;
    NSString *emailAuthType = [GVUserDefaults standardUserDefaults].email_auth_type;
    NSNumber *authedProductCount = [GVUserDefaults standardUserDefaults].authed_product_count;
    
    CGFloat total = 5.0;
    CGFloat cur = 0.0;
    if ([basicAuthType isEqualToString:kAuthTypeVerifyPass]) {
        cur += 1;
    }
    
    if ([teamAuthType isEqualToString:kAuthTypeVerifyPass]) {
        cur += 1;
    }
    
    if ([uidAuthType isEqualToString:kAuthTypeVerifyPass]) {
        cur += 1;
    }
    
    if ([emailAuthType isEqualToString:kAuthTypeVerifyPass]) {
        cur += 1;
    }
    
    if (authedProductCount.integerValue > 3) {
        cur += 1;
    }
    
    return cur / total;
}

@end
