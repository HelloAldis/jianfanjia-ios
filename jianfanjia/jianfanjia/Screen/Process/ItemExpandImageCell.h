//
//  ItemCell.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemExpandImageCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (void)initWithItem:(Item *)item sectionIndex:(NSInteger )sectionIndex itemIndex:(NSInteger)itemIndex forProcess:(Process *)process;

@end
