//
//  PhotoGroupCell.h
//  jianfanjia
//
//  Created by Karos on 16/5/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoGroupItemType) {
    PhotoGroupItemTypeOnline,
    PhotoGroupItemTypeOffline,
};

@class ReuseScrollView;
@class PhotoGroupView;

typedef void (^PhotoGroupItemLoadedBlock)(UIImage *image);

@interface PhotoGroupItem : NSObject

@property (nonatomic, assign) PhotoGroupItemType itemType;
@property (nonatomic, retain) UIImageView *thumbView;
@property (nonatomic, retain) UIImage *thumbImage;
@property (nonatomic, retain) NSString *imageid;
@property (nonatomic, readonly) UIImage *loadedImage;
@property (nonatomic, copy) PhotoGroupItemLoadedBlock loadedBlock;

@end

@protocol PhotoGroupViewProtocol <NSObject>

@optional
- (void)photoGrouopViewDidChangePage:(PhotoGroupView *)photoGroupView toPage:(NSInteger)toPage;
- (void)photoGrouopViewDidSingleTap:(PhotoGroupView *)photoGroupView;
- (void)photoGrouopViewWillLoadMore:(PhotoGroupView *)photoGroupView;

@end

@interface PhotoGroupView : UIView

@property (nonatomic, readonly) ReuseScrollView *scrollView;
@property (nonatomic, retain) NSArray<PhotoGroupItem *> *groupItems;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<PhotoGroupViewProtocol> delegate;

@end

@interface PhotoGroupAnimationView : PhotoGroupView

@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES

- (void)presentFromImageView:(UIView *)fromView
               fromItemIndex:(NSInteger)fromItemIndex
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
