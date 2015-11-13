//
//  ViewControllerContainer.h
//  AURA
//
//  Created by Aldis on 14-9-30.
//  Copyright (c) 2014年 AURA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ViewControllerContainer : NSObject

+ (void)showAfterLanching;
+ (void)showLogin;
+ (void)showProcess;
+ (void)showProduct:(NSString *)productid;
+ (void)showDesigner:(NSString *)designerid;
+ (void)showTab;
+ (void)showImageDetail:(NSArray *)images withIndex:(NSInteger)index;
+ (void)showRefresh;
+ (void)refreshSuccess;
+ (void)logout;

@end
