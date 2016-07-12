//
//  ImageBrowerViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//
#import <Photos/Photos.h>

typedef void (^FinishUploadBlock)(NSArray *imageIds, NSArray *imageSizes);

@interface ImageBrowerViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSString *vcTitle;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *result;

//UI
@property (assign, nonatomic) CGFloat cellCountInOneRow;
@property (assign, nonatomic) CGFloat cellSpace;

//selection
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (assign, nonatomic) NSInteger maxCount;

@property (assign, nonatomic) BOOL allowsEdit;

@property (assign, nonatomic) NSInteger style;

@property (copy, nonatomic) FinishUploadBlock finishUploadBlock;

@end
