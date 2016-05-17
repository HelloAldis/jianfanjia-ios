//
//  PhotoGroupCell.h
//  jianfanjia
//
//  Created by Karos on 16/5/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReuseScrollView;
@class PhotoGroupView;

typedef void (^PhotoGroupItemLoadedBlock)(UIImage *image);

@interface PhotoGroupItem : NSObject

@property (nonatomic, readonly) UIImage *loadedImage;
@property (nonatomic, strong) NSString *imageid;
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
@property (nonatomic, strong) NSArray<PhotoGroupItem *> *groupItems;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<PhotoGroupViewProtocol> delegate;

@end
