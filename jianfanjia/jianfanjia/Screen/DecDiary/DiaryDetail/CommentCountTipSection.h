//
//  ProductAuthImageHeaderView.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCommentCountTipSectionHeight 50

@interface CommentCountTipSection : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

+ (CommentCountTipSection *)commentCountTipSection;

@end
