//
//  AppDelegate.h
//  jianfanjia-supervisor
//
//  Created by Karos on 16/4/18.
//  Copyright © 2016年 jianfanjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstance;

@end
