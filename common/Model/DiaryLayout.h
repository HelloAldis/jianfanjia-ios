//
//  Diary.h
//  jianfanjia
//
//  Created by Karos on 16/6/15.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

#define kPicTopMarging 15       // pic top 外边距
#define kPicBottomMarging 20    // pic bottom 外边距
#define kPicPadding 20       // pic 内边距
#define kPicPaddingPic 4     // pic 多张图片中间留白
#define kPicContentWidth (kScreenWidth - 2 * kPicPadding) // cell 内容宽度

@interface DiaryLayout : NSObject

@property (nonatomic, weak) Diary *diary;
@property (nonatomic, assign) CGFloat truncateCellHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGSize picSize;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat truncateContentHeight;
@property (nonatomic, strong) YYTextLayout *truncateContentLayout;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) YYTextLayout *contentLayout;
@property (nonatomic, assign) BOOL needTruncate;
@property (nonatomic, copy) YYTextAction tapMoreAction;

- (void)layout;

@end
