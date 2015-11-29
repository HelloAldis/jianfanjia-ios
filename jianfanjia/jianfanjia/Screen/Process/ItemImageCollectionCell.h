//
//  ItemImageCollectionCell.h
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemImageCellDelegate <NSObject>

- (void) gridItemDidClicked:(UIView *) gridItem;
- (void) gridItemDidEnterEditingMode:(UIView *) gridItem;
- (void) gridItemDidDeleted:(UIView *) gridItem atIndex:(NSInteger)index;
- (void) gridItemDidMoved:(UIView *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*)recognizer;
- (void) gridItemDidEndMoved:(UIView *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer;
@end

@interface ItemImageCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property(nonatomic) BOOL isEditing;
@property(nonatomic) BOOL isRemovable;
@property(nonatomic) NSInteger index;
@property(weak,nonatomic)id<ItemImageCellDelegate> delegate;

- (id)initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable;
- (void)enableEditing;
- (void)disableEditing;

@end


