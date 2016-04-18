//
//  AppDelegate.m
//  jianfanjia-supervisor
//
//  Created by Karos on 16/4/18.
//  Copyright © 2016年 jianfanjia. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllerContainer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化日志
    [self initLog];
    
    self.window = [[UIWindow alloc] initWithFrame:kScreenFullFrame];
    [ViewControllerContainer showAfterLanching];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        NSString *todoy = [[NSDate date] yyyy_MM_dd];
        if (![todoy isEqualToString:[GVUserDefaults standardUserDefaults].loginDate]) {
            [ViewControllerContainer showRefresh];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)initLog {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    LogFormatter *formatter = [[LogFormatter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60*60*24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
    [fileLogger setLogFormatter:formatter];
    
    [DDLog addLogger:fileLogger];
    
#ifdef DEBUG
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
#endif
}

@end
