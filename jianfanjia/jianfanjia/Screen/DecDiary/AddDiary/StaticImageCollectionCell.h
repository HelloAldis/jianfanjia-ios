//
//  ItemImageCollectionCell.h
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StaticImageCollectionCell;

typedef void (^StaticImageColCellTapImageBlock)(StaticImageCollectionCell *cell);
typedef void (^StaticImageColCellTapDeleteBlock)(StaticImageCollectionCell *cell);

@interface StaticImageCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lblDeleteText;

@property (copy, nonatomic) StaticImageColCellTapImageBlock tapImageBlock;
@property (copy, nonatomic) StaticImageColCellTapDeleteBlock tapDeleteBlock;

- (void)initWithImageId:(NSString *)imageid;
- (void)initWithImage:(UIImage *)image;

@end


