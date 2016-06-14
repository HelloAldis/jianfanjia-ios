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
//#import "LeakMoniter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 推送注册
    [self initNotification:launchOptions];
    // 初始化第三方统计
    [self initThirdPartyStatistics];
    // 初始化第三方分享
    [self initThirdPartyShare];
    // 初始化日志
    [self initLog];
    
    self.window = [[UIWindow alloc] initWithFrame:kScreenFullFrame];
    [ViewControllerContainer showAfterLanching];
    [self.window makeKeyAndVisible];
//    [LeakMoniter start];
    
    return YES;
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [JYZSocialSnsManager handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return  [JYZSocialSnsManager handleOpenURL:url];
}

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - 第三方统计
- (void)initThirdPartyStatistics {
    // 友盟日志统计
    UMConfigInstance.appKey = kUMengAppKey;
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark - 第三方登录／分享
- (void)initThirdPartyShare {
    // 友盟第三方登录／分享
    [[JYZSocialSnsConfigCenter shared] registerWX:kWXAppId appsecret:kWXAppSecret];
    [[JYZSocialSnsConfigCenter shared] registerQQ:kQQAppId];
    [[JYZSocialSnsConfigCenter shared] registerWeibo:kWeiboAppKey rediectURI:nil];
}

#pragma mark - 用户通知(推送) _自定义方法
- (void)initNotification:(NSDictionary *)launchOptions {
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
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APN
    DDLogDebug(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);

    if(application.applicationState == UIApplicationStateInactive) {
        [[NotificationDataManager shared] remoteTriggerToShowDetail:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    } else if (application.applicationState == UIApplicationStateBackground) {
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if(application.applicationState == UIApplicationStateInactive) {
        [[NotificationDataManager shared] localTriggerToShowDetail:notification.userInfo];
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
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    NSData *payload = payloadData;
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId,payloadMsg,offLine ? @"<离线消息>" : @""];
    DDLogDebug(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    [[NotificationDataManager shared] receiveNotification:payload andOffLine:offLine];
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
