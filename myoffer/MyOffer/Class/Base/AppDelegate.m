 //
//  AppDelegate.m
//  MyOffer
//
//  Created by Blankwonder on 6/6/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "KDKeychain.h"
#import "IntroViewController.h"
#import "UserDefaults.h"
#import "MyOfferLoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "HomeViewContViewController.h"
#import "MQManager.h"


// 引入JPush功能所需头文件
//#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>// 如果需要使用idfa功能所需要引入的头文件（可选）

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>
{
    NSString *_accessToken;
 }
@property(nonatomic,strong)MyofferTabBarController *mainTabBarController;

@end

@implementation AppDelegate

static AppDelegate *__sharedDelegate;
+ (instancetype)sharedDelegate {
    return __sharedDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    __sharedDelegate = self;
    
#if DEBUG
    KDDebuggerInstallUncaughtExceptionHandler();
#else
    [Fabric with:@[CrashlyticsKit]];
#endif
    
    [[KDImageCache sharedInstance] setCachedImagePath:[[KDStroageHelper libraryDirectoryPath] stringByAppendingPathComponent:@"Images"]];
    
    [self loadSavedToken];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化语言文件
    [InternationalControl initUserLanguage];
    //创建主控制
    [self makeRootController];
    //友盟
    [self umeng];
    //极光
    [self JpushWithOptions:launchOptions];
    //美洽
    [self meiqia];
    
    return YES;
}

- (void)makeRootController
{
    //控制器初始化
    MyofferTabBarController *mainTabBarController  = [[MyofferTabBarController alloc] init];
    self.mainTabBarController = mainTabBarController;
    self.window.rootViewController = mainTabBarController;

    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //产品引导页面
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
    if (![[UserDefaults sharedDefault].introductionDismissBuildVersion isEqualToString:version]) {
        [self.window.rootViewController presentViewController:[[IntroViewController alloc] init] animated:NO completion:nil];
        [UserDefaults sharedDefault].introductionDismissBuildVersion = version;
    }

}
-(void)JpushWithOptions:(NSDictionary *)launchOptions //极光推送
{
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"c73db911f4f72b608e116576"
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
    //apsForProduction  1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。 0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。 注：此字段的值要与Build Settings的Code Signing配置的证书环境一致。
 
    
    
    //接收远程消息
    NSDictionary *userInfox = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfox) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfox];
        [self applicationBadgeNumber];
    }
    
  
}


-(void)umeng
{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5668ea43e0f55af981002131"];
    [self configUSharePlatforms];
    //友盟统计
    [self umengTrack];
    [WXApi registerApp:@"wx6ef4fb49781fdd34" withDescription:@"demo 2.0"];
 
}

- (void)configUSharePlatforms
{
    

    /*
     旧版 [UMSocialWechatHandler setWXAppId:@"wx6ef4fb49781fdd34" appSecret:@"" url:@"http://www.myoffer.cn/"];
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx6ef4fb49781fdd34" appSecret:@"776f9dafbfe76ffb6e20ff5a8e4c4177" redirectURL:@"http://www.myoffer.cn/"];
 
    /* 旧版  [UMSocialQQHandler setQQWithAppId:@"1104829804" appKey:@"qQUCI87bgI38XUut" url:@"http://www.myoffer.cn/"];
     设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1104829804"/*设置QQ平台的appID*/  appSecret:@"qQUCI87bgI38XUut" redirectURL:@"http://www.myoffer.cn/"];
    
    /*
     旧版   [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1584614386"  appSecret:@"3736ea71b1062eaf980a72e14184cf78" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
 
//     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Email appKey:nil appSecret:nil redirectURL:nil];
}
    


- (void)umengTrack {
    // [MobClick setAppVersion:XcodeAppVersion];
    //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"5668ea43e0f55af981002131";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}


- (void)meiqia{
    
    [MQManager initWithAppkey:@"edb45a1504a6f3bc86174cf8923b1006" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            KDClassLog(@"美洽 SDK：初始化成功");
        } else {
            KDClassLog(@"error:%@",error);
        }
    }];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    KDClassLog(@" didRegisterForRemoteNotificationsWithDeviceToken  %@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
    
    #pragma mark  集成第四步: 上传设备deviceToken
    [MQManager registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    KDClassLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    KDClassLog(@"iOS6及以下系统，收到通知: %@",userInfo);
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
    //iOS6及以下系统，收到通知:
    if (1 == [UIApplication sharedApplication].applicationState) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfo];
        [self applicationBadgeNumber];
    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    
    KDClassLog(@"iOS7及以上系统，收到通知:  %@ -- %ld",userInfo,[UIApplication sharedApplication].applicationState);
    //iOS7及以上系统，收到通知:
    if (1 == [UIApplication sharedApplication].applicationState) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfo];
        [self applicationBadgeNumber];
    }
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
 
}
//处理applicationIconBadgeNumber数据
-(void)applicationBadgeNumber
{
    
//    NSInteger Value = [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
//    NSInteger ValueNumber = Value > 0 ? Value : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber =  0;
    [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
}


- (void)presentLoginAndRegisterViewControllerAnimated:(BOOL)animated {
     MyofferNavigationController *nav =[[MyofferNavigationController alloc] initWithRootViewController:[[MyOfferLoginViewController alloc] init]];
    [self.window.rootViewController presentViewController:nav animated:YES completion:^{}];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    #pragma mark  集成第三步: 进入后台 关闭美洽服务
    [MQManager closeMeiqiaService];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    #pragma mark  集成第二步: 进入前台 打开meiqia服务
    [MQManager openMeiqiaService];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {

    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        KDLog(@"iOS10 前台收到远程通知:");
        if (1 == [UIApplication sharedApplication].applicationState) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfo];
            [self applicationBadgeNumber];
        }

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        KDLog(@"iOS10 收到远程通知:");
        if (1 == [UIApplication sharedApplication].applicationState) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfo];
            [self applicationBadgeNumber];
        }
    }
    else {
        // 判断为本地通知
        KDLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
    
}



- (BOOL)isLogin {
    
    
    NSString *logout_date  =  [[NSUserDefaults standardUserDefaults] valueForKey:@"logout_date"];
    
    //判断登录时间是否过期
    if (logout_date) {
        
        NSDate *now_date = [NSDate date];
        long long logout_time = logout_date.longLongValue;
        long long current_time = (long long)now_date.timeIntervalSince1970 * 1000;
        if (logout_time <= current_time) [self logout];
 
    }
    
    return _accessToken != nil;
}


- (void)loginWithAccessResponse:(NSDictionary *)response{
    
    [self loginWithAccessToken: response[@"access_token"]];
    
    [self saveLogOutDate:response[@"expiration_date"]];
    
}

- (void)loginWithAccessToken:(NSString *)token {
    
    _accessToken = token;
    
    [Keychain writeKeychainWithIdentifier:@"token" data:[token dataUsingEncoding:NSUTF8StringEncoding]];
    
}

- (void)logout {
    
    _accessToken = nil;
    
    [Keychain deleteKeychainItemWithIdentifier:@"token"];
}

- (NSString *)accessToken {

    
    return _accessToken;
}

- (void)loadSavedToken {
    
    NSString *savedToken = [[NSString alloc] initWithData:[Keychain keychainItemDataWithIdentifier:@"token"] encoding:NSUTF8StringEncoding];
 
    if (KDUtilIsStringValid(savedToken)) { 
        
          _accessToken = savedToken;
       }
}

//保存过期登录时间
- (void)saveLogOutDate:(NSString *)timeStr
{
//    NSLog(@" %@  <<<<<<保存过期登录时间>>>>>",timeStr);
    [[NSUserDefaults standardUserDefaults] setValue:timeStr forKey:@"logout_date"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}


#pragma mark 微信回调的代理方法
-(void)onReq:(BaseReq*)req{

    KDClassLog(@"onReq 微信  %@",[req class]);

}
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        NSString *errcode = [NSString stringWithFormat:@"%d",response.errCode];
        [[NSNotificationCenter  defaultCenter] postNotificationName:@"wxpay" object:errcode];
        switch (response.errCode) {
            case WXSuccess:
                KDClassLog(@"微信回调的代理方法 suceess %d",response.errCode);
                break;
            default:
                KDClassLog(@"微信回调的代理方法 failed %d",response.errCode);
                break;
        }
    }
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}


- (BOOL)applicationOpenURL:(NSURL *)url
{
    KDClassLog(@"aapplicationOpenURL: %@",url.absoluteString);
    //你的微信开发者appid
    if([[url absoluteString] rangeOfString:@"wx3b0cb66502388846://pay"].location == 0)
        return [WXApi handleOpenURL:url delegate:self];
    else
//        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
        
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"   跳转支付宝钱包进行支付 result = %@",resultDic);
        }];
        
        return YES;
        
    }else if([url.absoluteString containsString:@"wx3b0cb66502388846://pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        if (!result) {
            // 其他如支付等SDK的回调
        }
        return result;
        
    }

  
}
//
//// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
//    NSLog(@"    NOTE: 9.0以后使用新API接口   ");
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             KDClassLog(@"NOTE: 9.0 跳转支付宝钱包进行支付 result = %@",resultDic);
            [[NSNotificationCenter  defaultCenter] postNotificationName:@"alipay" object:resultDic[@"resultStatus"]];
            
        }];
        
         return YES;

    }else if([url.absoluteString containsString:@"wx3b0cb66502388846://pay"]){
        
        return [WXApi handleOpenURL:url delegate:self];
     
    }else{
    
        BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
        if (!result) {
            // 其他如支付等SDK的回调
        }
        return result;

    }
}




@end
