//
//  ItemImageCollectionCell.h
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemImageCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;

- (void)initWithImage:(NSString *)imageid width:(CGFloat)width deleteBlock:(void(^)(void))DeleteBlock;
- (void)startShaking;
- (void)endShaking;

@end


