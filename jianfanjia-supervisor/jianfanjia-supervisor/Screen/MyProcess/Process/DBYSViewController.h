//
//  ProcessViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface DBYSViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (id)initWithSection:(Section *)section process:(NSString *)processid popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock;

@end
