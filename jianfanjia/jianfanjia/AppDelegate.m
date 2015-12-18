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
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // 个推推送注册
    [self initNotification:launchOptions];
    // 友盟日志统计
    [MobClick startWithAppkey:@"55ffb334e0f55a84d500247f" reportPolicy:BATCH channelId:@"default"];
    
    [self initLog];
    self.window = [[UIWindow alloc] initWithFrame:kScreenFullFrame];
    [ViewControllerContainer showAfterLanching];
    [self.window makeKeyAndVisible];
    [LeakMoniter start];
    
    return YES;
}

- (void)initLog {
    LogFormatter *formatter = [[LogFormatter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60*60*24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
    [fileLogger setLogFormatter:formatter];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:fileLogger];
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
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
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - 用户通知(推送) _自定义方法
- (void)initNotification:(NSDictionary *)launchOptions {
    [[NotificationDataManager shared] refreshUnreadCount];
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册APNS
    [self registerUserNotification];
    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
}

/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    
    // 定义用户通知设置
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    // 注册用户通知 - 根据用户通知设置
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions) return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    DDLogDebug(@"\n>>>[Launching RemoteNotification]:%@",userInfo);
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用
/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [GeTuiSdk registerDeviceToken:myToken];
    DDLogDebug(@"\n>>>[DeviceToken Success]:%@\n\n",myToken);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [GeTuiSdk registerDeviceToken:@""];
    DDLogDebug(@"\n>>>[DeviceToken Error]:%@\n\n",error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理
/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;        // 标签
    DDLogDebug(@"\n>>>[Receive RemoteNotification]:%@\n\n",userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APN
    DDLogDebug(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    if(application.applicationState == UIApplicationStateInactive) {
        DDLogDebug(@"Inactive");
        //Show the view with the content of the push
        completionHandler(UIBackgroundFetchResultNewData);
    } else if (application.applicationState == UIApplicationStateBackground) {
        DDLogDebug(@"Background");
        //Refresh the local model
//        NSNumber *current = @(application.applicationIconBadgeNumber);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1)), dispatch_get_main_queue(), ^{
//                NSNumber *serverBadge = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
//                application.applicationIconBadgeNumber = current.intValue + serverBadge.intValue;
//                DDLogDebug(@"Background server:%@ current:%@ total:%@", serverBadge, current, @(application.applicationIconBadgeNumber));
//        });
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        DDLogDebug(@"Active");
        //Show an in-app banner
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

#pragma mark - GeTuiSdkDelegate
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    DDLogDebug(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        [GeTuiSdk bindAlias:[GVUserDefaults standardUserDefaults].userid];
    }
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    DDLogDebug(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId {
    // [4]: 收到个推消息
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@" payloadId=%@,taskId=%@,messageId:%@,payloadMsg:%@%@",payloadId,taskId,aMsgId,payloadMsg,offLine ? @"<离线消息>" : @""];
    DDLogDebug(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    [[NotificationDataManager shared] receiveNotification:payload];
    
    /**
     *汇报个推自定义事件
     *actionId：用户自定义的actionid，int类型，取值90001-90999。
     *taskId：下发任务的任务ID。
     *msgId： 下发任务的消息ID。
     *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
     **/
//    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:aMsgId];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    DDLogDebug(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n",msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    DDLogDebug(@"\n>>>[GexinSdk SdkState]:%u\n\n",aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        DDLogDebug(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n",[error localizedDescription]);
        return;
    }

    DDLogDebug(@"\n>>>[GexinSdk SetModeOff]:%@\n\n",isModeOff?@"开启":@"关闭");
}

@end
