//
//  MeViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface EmailAuthSuccessViewController : BaseViewController

@property (nonatomic, strong) Designer *designer;

- (instancetype)initWithDesigner:(Designer *)designer;

@end
