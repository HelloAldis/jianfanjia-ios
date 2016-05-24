//
//  ImageBrowerViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//
#import <Photos/Photos.h>

typedef void (^FinishUploadBlock)(NSArray *imageIds);

@interface ImageBrowerViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

//UI
@property (assign, nonatomic) CGFloat cellCountInOneRow;
@property (assign, nonatomic) CGFloat cellSpace;

//selection
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (assign, nonatomic) NSInteger maxCount;

@property (assign, nonatomic) BOOL allowsEdit;

@property (copy, nonatomic) FinishUploadBlock finishUploadBlock;

@end
