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
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
//#import "NewLoginRegisterViewController.h"
#import "MyOfferLoginViewController.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "LeftMenuViewController.h"
#import "APService.h"
#import "RNCachingURLProtocol.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "HomeViewContViewController.h"


@interface AppDelegate ()<RESideMenuDelegate,WXApiDelegate>
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
    
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc] init];
    leftMenuViewController.mainTabBarController = mainTabBarController;
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:mainTabBarController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    
    sideMenuViewController.view.backgroundColor = XCOLOR(54, 54, 54 , 1);
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;

    
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
    // 5606655f67e58e9f00004355
    //在AppDelegate内设置友盟AppKey
    [UMSocialData setAppKey:@"5668ea43e0f55af981002131"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx6ef4fb49781fdd34" appSecret:@"776f9dafbfe76ffb6e20ff5a8e4c4177" url:@"http://www.myoffer.cn/"];
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
   
     [WXApi registerApp:@"wx6ef4fb49781fdd34" withDescription:@"demo 2.0"];

}

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

        NSInteger time_count = logout_date.integerValue - (NSInteger)now_date.timeIntervalSince1970 * 1000;
        
        if (time_count <= 0) [self logout];
 
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    KDClassLog(@"application handleOpenURL------- %@",url.absoluteString);

    return  [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)applicationOpenURL:(NSURL *)url
{
    
    KDClassLog(@"aapplicationOpenURL------- %@",url.absoluteString);
    if([[url absoluteString] rangeOfString:@"wx3b0cb66502388846://pay"].location == 0) //你的微信开发者appid
        return [WXApi handleOpenURL:url delegate:self];
    else
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
}

//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    
//    NSLog(@"application openURL:(NSURL *)url sourceApplication------- %@",url.absoluteString);
//    
//    return [WXApi handleOpenURL:url delegate:self];
//}


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
        
        BOOL result = [UMSocialSnsService handleOpenURL:url];
        if (result == FALSE) {
            //调用其他SDK，例如支付宝SDK等
            
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
    
        BOOL result = [UMSocialSnsService handleOpenURL:url];
        if (result == FALSE) {
            //调用其他SDK，例如支付宝SDK等
            
            
        }
        return result;

    }
}




#pragma mark  RESideMenuDelegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{

    [self.mainTabBarController contentViewIsOpen:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    NSLog(@"willShowMenuViewController: %@ ", NSStringFromClass([menuViewController class]));
    
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{

       [self.mainTabBarController contentViewIsOpen:NO];
//        NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
    
    if (self.mainTabBarController.selectedIndex == 0) {
        
        UINavigationController *nav = self.mainTabBarController.childViewControllers[self.mainTabBarController.selectedIndex];
        
        HomeViewContViewController *home = (HomeViewContViewController *)nav.childViewControllers.firstObject;
        
        [home caseChangestatusBarStyle];
    }
    
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{

//    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));

 
}






@end
