//
//  SelectRoomTypeViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DiarySetLeftMenuViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) CGFloat width;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
