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
#import "UMSocialWechatHandler.h"
#import "MyOfferLoginViewController.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "APService.h"
#import "RNCachingURLProtocol.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "HomeViewContViewController.h"

@interface AppDelegate ()<WXApiDelegate>
{
    NSString *_accessToken;
 }
@property(nonatomic,strong)XWGJTabBarController *mainTabBarController;

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

    //[NSURLProtocol registerClass:[RNCachingURLProtocol class]];//用于缓存
    
    //友盟
    [self umeng];
    
    //极光
    [self Jpush];
    
    //极光
    [APService setupWithOption:launchOptions];
    
    //接收远程消息
    NSDictionary *userInfox = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfox) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfox];
        
         [self applicationBadgeNumber];
    }
 
    
    /* 开发者的美洽  #import <MeiQiaSDK/MQManager.h>

    [MQManager initWithAppkey:@"edb45a1504a6f3bc86174cf8923b1006" completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
        }
//        [MQServiceToViewInterface getUnreadMessagesWithCompletion:^(NSArray *messages, NSError *error) {
//            NSLog(@">> unread message count: %d", (int)messages.count);
//        }];
    }];
     
     */
    
    return YES;
}

- (void)makeRootController
{
    //控制器初始化
    XWGJTabBarController *mainTabBarController  = [[XWGJTabBarController alloc] init];
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
-(void)Jpush //极光推送
{
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    /*
    else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
   */
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService setBadge:0];


  
}


-(void)umeng
{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5668ea43e0f55af981002131"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    
    //友盟统计
    [self umengTrack];
    
    [WXApi registerApp:@"wx6ef4fb49781fdd34" withDescription:@"demo 2.0"];
 
}


- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
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
     App Key：
     9614439
     App Sercet：
     c768c74b50a83201de5ed201b2472971
     旧版   [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"9614439"  appSecret:@"c768c74b50a83201de5ed201b2472971" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}
    


- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"5668ea43e0f55af981002131";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}

/*
-(void)updateUmeng
{
    // 5606655f67e58e9f00004355
    //在AppDelegate内设置友盟AppKey
    [UMSocialData setAppKey:@"5668ea43e0f55af981002131"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx3b0cb66502388846" appSecret:@"5e410534cd1657326777084f1a7a3181" url:@"http://www.myoffer.cn/"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置QQ登录
    [UMSocialQQHandler setQQWithAppId:@"1104829804" appKey:@"qQUCI87bgI38XUut" url:@"http://www.myoffer.cn/"];
    //友盟统计
    [MobClick startWithAppkey:@"5668ea43e0f55af981002131" reportPolicy:BATCH   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    [MobClick setEncryptEnabled:YES];
    [MobClick setLogEnabled:YES];
    
//    [WXApi registerApp:@"wx3b0cb66502388846" withDescription:@"demo 2.0"];
    [WXApi registerApp:@"wx6ef4fb49781fdd34" withDescription:@"demo 2.0"];

 }
*/
 
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    KDClassLog(@" didRegisterForRemoteNotificationsWithDeviceToken  %@",deviceToken);
    // Required
    [APService registerDeviceToken:deviceToken];
    
    /*美洽  上传设备的 deviceToken
    [MQManager registerDeviceToken:deviceToken];
    */

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    KDClassLog(@"IOS <= 6   didReceiveRemoteNotification  %@",userInfo);
    // Required
    
    if (1 == [UIApplication sharedApplication].applicationState) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfo];
        
        [self applicationBadgeNumber];
    }

    [APService handleRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    
    KDClassLog(@"IOS 7   didReceiveRemoteNotification  %@ -- %ld",userInfo,[UIApplication sharedApplication].applicationState);
    
    if (1 == [UIApplication sharedApplication].applicationState) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfo];
        
        [self applicationBadgeNumber];
    }
    
      // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
 
}
//处理applicationIconBadgeNumber数据
-(void)applicationBadgeNumber
{
    
    NSInteger Value = [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
    
    NSInteger ValueNumber = Value > 0 ? Value : 0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =  ValueNumber;
    
    [APService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
}


- (void)presentLoginAndRegisterViewControllerAnimated:(BOOL)animated {
    
//    NewLoginRegisterViewController *vc = [[NewLoginRegisterViewController alloc] initWithNibName:@"NewLoginRegisterViewController" bundle:nil];
     XWGJNavigationController *nav =[[XWGJNavigationController alloc] initWithRootViewController:[[MyOfferLoginViewController alloc] init]];
    [self.window.rootViewController presentViewController:nav animated:YES completion:^{}];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    /*美洽
      [MQManager closeMeiqiaService];
     */
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    /*美洽
     [MQManager openMeiqiaService];
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)isLogin {
    
    
    NSString *logout_date  =  [[NSUserDefaults standardUserDefaults] valueForKey:@"logout_date"];
    
    //判断登录时间是否过期
    if (logout_date) {
        
        NSDate *now_date = [NSDate date];
        long long logout_time = logout_date.longLongValue;
        long long current_time = (long long)now_date.timeIntervalSince1970 * 1000;

//        NSLog(@"%@  int = %lld  <<<<<<判断登录时间是否过期>>>>> %lld",logout_date,logout_time,current_time);
        
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
    
    KDClassLog(@"aapplicationOpenURL------- %@",url.absoluteString);
    if([[url absoluteString] rangeOfString:@"wx3b0cb66502388846://pay"].location == 0) //你的微信开发者appid
        return [WXApi handleOpenURL:url delegate:self];
    else
//        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   
//    NSLog(@"   以后使用新API接口   ");
    
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
