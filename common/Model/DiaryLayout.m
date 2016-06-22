//
//  Diary.m
//  jianfanjia
//
//  Created by Karos on 16/6/15.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DiaryLayout.h"

@interface DiaryLayout ()

@property (nonatomic, strong) YYTextHighlight *moreTextHighlight;

@end

@implementation DiaryLayout

- (void)layout {
    [self calcContengLayout];
    [self calcImagesLayout];
}

- (void)calcContengLayout {
    if (self.needTruncate) {
        if (self.truncateContentHeight > 0) {
            self.moreTextHighlight.tapAction = self.tapMoreAction;;
            return;
        }
        
        self.truncateContentHeight = 0;
        self.truncateContentLayout = nil;
    } else {
        if (self.contentHeight > 0) {
            self.moreTextHighlight.tapAction = self.tapMoreAction;
            return;
        }
        
        self.contentHeight = 0;
        self.contentLayout = nil;
    }
    
    if (!self.diary.content) return;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.diary.content];
    [text yy_setColor:[UIColor colorWithR:0x7C g:0x84 b:0x89] range:NSMakeRange(0, text.length)];
    [text yy_setFont:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, text.length)];
    
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 24;
    
    YYTextContainer *container = [YYTextContainer new];
    container.insets = UIEdgeInsetsMake(5, 20, 15, 10);
    container.size = CGSizeMake(kScreenWidth, CGFLOAT_MAX);
    container.linePositionModifier = modifier;
    container.truncationType = YYTextTruncationTypeEnd;
    container.truncationToken = [self truncationToken];
    container.maximumNumberOfRows = self.needTruncate ? 6 : 0;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    if (self.needTruncate) {
        self.truncateContentHeight = layout.textBoundingSize.height;
        self.truncateContentLayout = layout;
    } else {
        self.contentHeight = layout.textBoundingSize.height;
        self.contentLayout = layout;
    }
}

- (NSAttributedString *)truncationToken {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...      全文"];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    [hi setFont:[UIFont systemFontOfSize:13]];
    hi.tapAction = self.tapMoreAction;
    self.moreTextHighlight = hi;
    
    [text yy_setColor:[UIColor colorWithR:0x7C g:0x84 b:0x89] range:[text.string rangeOfString:@"...      "]];
    [text yy_setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:@"全文"]];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"全文"]];
    [text yy_setFont:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, text.length)];
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    return truncationToken;
}

- (void)calcImagesLayout {
    if (self.picHeight > 0) {
        return;
    }
    
    NSArray *pics = self.diary.images;
    
    self.picSize = CGSizeZero;
    self.picHeight = 0;
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
    
    self.picSize = picSize;
    self.picHeight = picHeight + kPicTopMarging + kPicBottomMarging;
}

@end
