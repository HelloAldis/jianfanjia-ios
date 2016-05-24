//
//  ProductAuthImageHeaderView.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kImgViewWidth 40
#define kImgViewSpace 24
#define kProductAuthImageActionViewWidth (3 * (kImgViewWidth + kImgViewSpace))
#define kProductAuthImageActionViewHeight 41

typedef NS_ENUM(NSInteger, ProductAuthImageAction) {
    ProductAuthImageActionDelete,
    ProductAuthImageActionEdit,
    ProductAuthImageActionSetCover,
};

typedef void (^ProductAuthImageActionViewTapBlock)(ProductAuthImageAction);

@interface ProductAuthImageActionView : UIView

@property (nonatomic, copy) ProductAuthImageActionViewTapBlock tapBlock;

@end
