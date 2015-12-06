//
//  BaseSelectionViewController.h
//  jianfanjia
//
//  Created by likaros on 15/12/6.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ValueBlock)(id value);

@interface BaseSelectionViewController : BaseViewController

@property (copy, nonatomic) ValueBlock ValueBlock;

- (id)initWithValueBlock:(ValueBlock)ValueBlock;

@end
