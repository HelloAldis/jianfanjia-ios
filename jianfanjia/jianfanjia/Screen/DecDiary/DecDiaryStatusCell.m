//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecDiaryStatusCell.h"
#import "ViewControllerContainer.h"

@interface DecDiaryStatusCell ()

@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgsHeightConst;
@property (weak, nonatomic) IBOutlet YYLabel *msgView;
@property (weak, nonatomic) IBOutlet UIView *imgsView;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;

@property (strong, nonatomic) NSMutableArray *picViews;
@property (nonatomic, copy) YYTextAction tapMoreAction;

@property (strong, nonatomic) Diary *diary;

@end

@implementation DecDiaryStatusCell

- (void)awakeFromNib {
    [self.designerImageView setCornerRadius:30];
    self.msgView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.msgView.displaysAsynchronously = YES;
    self.msgView.ignoreCommonProperties = YES;
    self.msgView.fadeOnAsynchronouslyDisplay = NO;
    self.msgView.fadeOnHighlight = NO;
    
    @weakify(self);
    self.tapMoreAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        @strongify(self);
    };
    
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(0, 0, 100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.exclusiveTouch = YES;
        
        [picViews addObject:imageView];
        [self.imgsView addSubview:imageView];
    }
    
    self.picViews = picViews;
}

- (void)updateConstraints {
    self.msgHeightConst.constant = self.diary.layout.needTruncate ? self.diary.layout.truncateContentHeight : self.diary.layout.contentHeight;
    self.imgsHeightConst.constant = self.diary.layout.picHeight;
    [super updateConstraints];
}

- (void)initWithDiary:(Diary *)diary truncate:(BOOL)needTruncate {
    self.diary = diary;
    self.diary.layout.needTruncate = needTruncate;
    self.diary.layout.tapMoreAction = self.tapMoreAction;
    [self.diary.layout layout];
    
    [self initImageView];
    [self initMsg];
}

#pragma mark - ui
- (void)initMsg {
    self.msgView.text = self.diary.content;
    self.msgView.textLayout = self.diary.layout.needTruncate ? self.diary.layout.truncateContentLayout : self.diary.layout.contentLayout;
}

#pragma mark - layout
- (void)initImageView {
    NSArray *pics = self.diary.images;
    
    CGFloat imageTop = kPicTopMarging;
    CGSize picSize = self.diary.layout.picSize;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = self.picViews[i];
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
            [imageView setImageWithId:pic.imageid withWidth:kScreenWidth completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
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
