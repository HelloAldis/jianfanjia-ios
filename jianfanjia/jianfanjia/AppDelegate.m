//
//  AppDelegate.m
//  jianfanjia
//
//  Created by JYZ on 15/8/21.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewControllerContainer.h"
#import "API.h"
#import "LeakMoniter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initLog];
    
    self.window = [[UIWindow alloc] initWithFrame:kScreenFullFrame];
    [ViewControllerContainer showAfterLanching];
    [self.window makeKeyAndVisible];
//    Login *login = [[Login alloc] init];
//    [login setPhone:@"18107218595"];
//    [login setPass:@"654321"];
//    
//    DDLogDebug(@"%@", login);
//    [API login:login success:^{} failure:^{}];
//    [API getUserRequirementSuccess:nil failure:nil];
    [LeakMoniter start];
    
    return YES;
}

- (void)initLog {
    LogFormatter *formatter = [[LogFormatter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 5*60;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
    [fileLogger setLogFormatter:formatter];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:fileLogger];
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [LeakMoniter end];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        NSString *todoy = [[NSDate date] yyyy_MM_dd];
        if (![todoy isEqualToString:[GVUserDefaults standardUserDefaults].loginDate]) {
            [ViewControllerContainer showRefresh];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)sharedInstance {
    return [UIApplication sharedApplication].delegate;
}

@end
