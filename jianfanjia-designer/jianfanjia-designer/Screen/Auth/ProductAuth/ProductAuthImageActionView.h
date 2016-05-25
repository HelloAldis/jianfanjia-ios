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
#define kProductAuthImageActionViewWidth (4 * (kImgViewWidth + kImgViewSpace))
#define kProductAuthImageActionViewHeight 41

typedef NS_ENUM(NSInteger, ProductAuthImageAction) {
    ProductAuthImageActionDelete,
    ProductAuthImageActionEdit,
    ProductAuthImageActionSetCover,
};

typedef void (^ProductAuthImageActionViewTapBlock)(ProductAuthImageAction action);

@interface ProductAuthImageActionView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *closeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImgView;
@property (weak, nonatomic) IBOutlet UIImageView *editImgView;
@property (weak, nonatomic) IBOutlet UIImageView *setCoverImgView;

@property (nonatomic, copy) ProductAuthImageActionViewTapBlock tapBlock;

@end
