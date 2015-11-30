//
//  ImageBrowerViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^FinishUploadBlock)(NSArray *imageIds);

@interface ImageBrowerViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>

//UI
@property (assign, nonatomic) CGFloat cellCountInOneRow;
@property (assign, nonatomic) CGFloat cellSpace;

//selection
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (assign, nonatomic) int maxCount;

@property (copy, nonatomic) FinishUploadBlock finishUploadBlock;

@end
