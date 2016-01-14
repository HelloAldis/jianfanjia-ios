//
//  DropdownMenuView.h
//  jianfanjia
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DropdownChooseItemBlock)(id value);

@interface DropdownMenuView : UIView

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)initWithDataSource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue block:(DropdownChooseItemBlock)block;

@end
