//
//  UINavigationController+FPS.h
//  jianfanjia
//
//  Created by Karos on 16/7/15.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPSLabel.h"

@interface UINavigationController (FPS)

@property (nonatomic, strong) FPSLabel *fpsLabel;

- (void)setupFPS;

@end
