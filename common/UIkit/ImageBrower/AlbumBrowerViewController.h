//
//  ImageBrowerViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//
#import <Photos/Photos.h>
#import "ImageBrowerViewController.h"

typedef void (^DidChooseAlbumBlock)(NSString *title, PHFetchResult<PHAsset *> *result);

@interface AlbumBrowerViewController : UIViewController

@property (copy, nonatomic) DidChooseAlbumBlock didChooseAlbumBlock;

@end
