//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecDiaryStatusCell.h"
#import "ViewControllerContainer.h"

#define kPicTopMarging 20       // pic top 外边距
#define kPicBottomMarging 20    // pic bottom 外边距
#define kPicPadding 20       // pic 内边距
#define kPicPaddingPic 4     // pic 多张图片中间留白
#define kPicContentWidth (kScreenWidth - 2 * kPicPadding) // cell 内容宽度

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
@property (assign, nonatomic) BOOL needTruncate;

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

- (void)initWithDiary:(Diary *)diary truncate:(BOOL)needTruncate {
    self.diary = diary;
    self.needTruncate = needTruncate;
    
    [self initImageView];
    [self initMsg];
}

#pragma mark - ui
- (void)initMsg {
    if (self.diary.contentHeight == 0) {
        [self calcMsgViewHeight];
    }
    
    self.msgView.text = self.diary.content;
    self.msgView.textLayout = self.diary.contentLayout;
    self.msgHeightConst.constant = self.diary.contentHeight;
}

#pragma mark - layout
- (void)initImageView {
    if (self.diary.picHeight == 0) {
        [self calcPicViewHeight];
    }
    
    self.imgsHeightConst.constant = self.diary.picHeight;
    NSArray *pics = self.diary.images;
    
    CGFloat imageTop = kPicTopMarging;
    CGSize picSize = self.diary.picSize;
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

#pragma mark - calculate
- (void)calcMsgViewHeight {
    self.diary.contentHeight = 0;
    self.diary.contentLayout = nil;
    
    if (!self.diary.content) return;

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.diary.content];
    [text yy_setColor:[UIColor colorWithR:0x7C g:0x84 b:0x89] range:NSMakeRange(0, text.length)];
    [text yy_setFont:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, text.length)];
    
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 24;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX);
    container.linePositionModifier = modifier;
    container.truncationType = YYTextTruncationTypeEnd;
    container.truncationToken = [self truncationToken];
    container.maximumNumberOfRows = self.needTruncate ? 6 : 0;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    self.diary.contentHeight = layout.textBoundingSize.height;
    self.diary.contentLayout = layout;
}

- (NSAttributedString *)truncationToken {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    [hi setFont:[UIFont systemFontOfSize:13]];
    hi.tapAction = self.tapMoreAction;
    
    [text yy_setColor:[UIColor colorWithR:0x7C g:0x84 b:0x89] range:[text.string rangeOfString:@"..."]];
    [text yy_setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:@"全文"]];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"全文"]];
    [text yy_setFont:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, text.length)];
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    return truncationToken;
}

- (void)calcPicViewHeight {
    NSArray *pics = self.diary.images;
    
    self.diary.picSize = CGSizeZero;
    self.diary.picHeight = 0;
    if (pics.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kPicContentWidth - 2 * kPicPaddingPic) / 3;
    switch (pics.count) {
        case 1: {
            LeafImage *pic = [[LeafImage alloc] initWith:pics[0]];
            if (pic.width.intValue < 1 || pic.height.intValue < 1) {
                CGFloat maxLen = kPicContentWidth / 2.0;
                picSize = CGSizeMake(maxLen, maxLen);
                picHeight = maxLen;
            } else {
                CGFloat maxLen = len1_3 * 2 + kPicPaddingPic;
                if (pic.width.intValue < pic.height.intValue) {
                    picSize.width = (float)pic.width.intValue / (float)pic.height.intValue * maxLen;
                    picSize.height = maxLen;
                } else {
                    picSize.width = maxLen;
                    picSize.height = (float)pic.height.intValue / (float)pic.width.intValue * maxLen;
                }
                
                picHeight = picSize.height;
            }
        } break;
        case 2: case 3: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kPicPaddingPic;
        } break;
        default: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kPicPaddingPic * 2;
        } break;
    }
    
    self.diary.picSize = picSize;
    self.diary.picHeight = picHeight + kPicTopMarging + kPicBottomMarging;
}

@end
