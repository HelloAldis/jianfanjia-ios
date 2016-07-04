//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseDecDiaryStatusCell.h"
#import "ViewControllerContainer.h"
#import "PhotoGroupView.h"

@interface BaseDecDiaryStatusCell ()

@end

@implementation BaseDecDiaryStatusCell


#pragma mark - ui
- (void)initImageView {
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(0, 0, 100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.exclusiveTouch = YES;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)]];
        
        [picViews addObject:imageView];
        [self.base_imgsView addSubview:imageView];
    }
    
    self.base_picViews = picViews;
}

- (void)layoutMsg {
    self.base_msgHeightConst.constant = self.diary.layout.needTruncate ? self.diary.layout.truncateContentHeight : self.diary.layout.contentHeight;
    self.base_msgView.textLayout = self.diary.layout.needTruncate ? self.diary.layout.truncateContentLayout : self.diary.layout.contentLayout;
}

- (void)initToolbar {
    self.base_zanImgView.image = [self.diary.is_my_favorite boolValue] ? [self likeImage] : [self unlikeImage];
    if ([self.diary.favorite_count integerValue] > 0) {
        self.base_lblZan.text = [self.diary.favorite_count humCountString];
    } else {
        self.base_lblZan.text = @"赞";
    }
    
    if ([self.diary.comment_count integerValue] > 0) {
        self.base_lblComment.text = [self.diary.comment_count humCountString];
    } else {
        self.base_lblComment.text = @"评论";
    }
}

#pragma mark - user action
- (void)onTapImage:(UITapGestureRecognizer *)g {
    NSInteger index = [self.base_picViews indexOfObject:g.view];
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];

    for (NSUInteger i = 0, max = self.diary.images.count; i < max; i++) {
        UIImageView *imgView = self.base_picViews[i];

        PhotoGroupItem *item = [PhotoGroupItem new];
        item.thumbView = imgView;
        item.imageid = self.diary.images[i][@"imageid"];
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    PhotoGroupAnimationView *v = [[PhotoGroupAnimationView alloc] init];
    v.groupItems = items;
    [v presentFromImageView:fromView toContainer:[ViewControllerContainer getCurrentTopController].view animated:YES completion:nil];
}

- (void)onClickZan {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            if (![self.diary.is_my_favorite boolValue]) {
                [self setLiked:YES withAnimation:YES];
                
                ZanDiary *request = [[ZanDiary alloc] init];
                request.diaryid = self.diary._id;
                
                [API zanDiary:request success:^{
                } failure:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setLiked:NO withAnimation:YES];
                    });
                } networkError:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setLiked:NO withAnimation:YES];
                    });
                }];
            }
        }
    }];
}

- (UIImage *)likeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"icon_zan_guo"];
    });
    return img;
}

- (UIImage *)unlikeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"icon_zan"];
    });
    return img;
}

- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation {
    Diary *diary = self.diary;
    UIImageView *imgView = self.base_zanImgView;
    UILabel *lblCount = self.base_lblZan;
    if ([diary.is_my_favorite boolValue] == liked) return;
    
    UIImage *image = liked ? [self likeImage] : [self unlikeImage];
    int newCount = diary.favorite_count.intValue;
    newCount = liked ? newCount + 1 : newCount - 1;
    if (newCount < 0) newCount = 0;
    if (liked && newCount < 1) newCount = 1;
    
    NSString *newCountDesc;
    if (newCount > 0) {
        newCountDesc = [@(newCount) humCountString];
    } else {
        newCountDesc = @"赞";
    }
    
    diary.is_my_favorite = [NSNumber numberWithBool:liked];
    diary.favorite_count = @(newCount);
    
    if (!animation) {
        imgView.image = image;
        lblCount.text = newCountDesc;
        return;
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [imgView.layer setValue:@(1.7) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        imgView.image = image;
        lblCount.text = newCountDesc;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [imgView.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [imgView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}


#pragma mark - layout
- (void)layoutImageView {
    self.base_imgsHeightConst.constant = self.diary.layout.picHeight;
    NSArray *pics = self.diary.images;
    
    CGFloat imageTop = kPicTopMarging;
    CGSize picSize = self.diary.layout.picSize;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = self.base_picViews[i];
        if (i >= picsCount) {
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kPicPadding;
                    origin.y = imageTop;
                } break;
                case 4: {
                    origin.x = kPicPadding + (i % 2) * (picSize.width + kPicPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kPicPaddingPic);
                } break;
                default: {
                    origin.x = kPicPadding + (i % 3) * (picSize.width + kPicPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kPicPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            LeafImage *pic = [[LeafImage alloc] initWith:pics[i]];
            
            @weakify(imageView);
            [imageView setImageWithId:pic.imageid withWidth:imageView.frame.size.width completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
                @strongify(imageView);
                if (!imageView) return;
                if (image && stage == YYWebImageStageFinished) {
                    int width = [pic.width intValue];
                    int height = [pic.height intValue];
                    CGFloat scale = (height / width) / (imageView.frame.size.height / imageView.frame.size.width);
                    if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                    } else { // 高图只保留顶部
                        imageView.contentMode = UIViewContentModeScaleToFill;
                        imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                    }
                    
                    if (from != YYWebImageFromMemoryCacheFast) {
                        CATransition *transition = [CATransition animation];
                        transition.duration = 0.15;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                        transition.type = kCATransitionFade;
                        [imageView.layer addAnimation:transition forKey:@"contents"];
                    }
                }
                
            }];
        }
    }
}

@end
