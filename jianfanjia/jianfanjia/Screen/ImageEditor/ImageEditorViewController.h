//
//  ImageEditorViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"
#import <Photos/Photos.h>

@interface ImageEditorViewController : BaseViewController

@property (strong, nonatomic) PHAsset *asset;
@property (copy, nonatomic) FinishUploadBlock finishUploadBlock;

@end
