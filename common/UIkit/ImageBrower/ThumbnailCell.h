//
//  ThumbnailCell.h
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ThumbnailCell : UICollectionViewCell

- (void)initWithPHAsset:(PHAsset *)asset hidden:(BOOL)hideCheckmark checked:(void(^)(BOOL currentSelect))CheckBlock detail:(void(^)(void))DetailBlock;

@end
