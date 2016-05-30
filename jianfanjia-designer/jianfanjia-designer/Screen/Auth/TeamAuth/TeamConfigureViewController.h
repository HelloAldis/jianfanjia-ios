//
//  DesignerListViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^TeamConfigureCompletionBlock)(BOOL completion);

@interface TeamConfigureViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithRequirement:(Requirement *)requirement startTime:(NSNumber *)startTime  completion:(TeamConfigureCompletionBlock)completion;

@end
