//
//  ImageDetailViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface BeautifulImageHomePageViewController : BaseViewController<UIScrollViewDelegate>

- (id)initWithBeautifulImage:(BeautifulImage *)beautifulImage index:(NSInteger)index;

@end
