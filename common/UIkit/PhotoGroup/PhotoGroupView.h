//
//  PhotoGroupCell.h
//  jianfanjia
//
//  Created by Karos on 16/5/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PhotoGroupItemLoadedBlock)(UIImage *image);

@interface PhotoGroupItem : NSObject

@property (nonatomic, readonly) UIImage *loadedImage;
@property (nonatomic, strong) NSString *imageid;
@property (nonatomic, copy) PhotoGroupItemLoadedBlock loadedBlock;

@end

@interface PhotoGroupView : UIView

@property (nonatomic, strong) NSArray<PhotoGroupItem *> *groupItems;
@property (nonatomic, assign) NSInteger index;

@end
