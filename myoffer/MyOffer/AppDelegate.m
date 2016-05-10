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
#import "DiscoverViewController.h"
#import "MeViewController.h"
#import "IntroViewController.h"
#import "UserDefaults.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "NewLoginRegisterViewController.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "XWGJLeftMenuViewController.h"
#import "APService.h"
#import "NotificationViewController.h"
#import "RNCachingURLProtocol.h"

@interface AppDelegate ()<RESideMenuDelegate>
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
 
    
    [self makeRootController];
    
    
//    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];//用于缓存
    
    [self umeng];//友盟
    
    [self Jpush];//极光
    
    // Required
    [APService setupWithOption:launchOptions];
   
    NSDictionary *userInfox = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfox) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:userInfox];
        
         [self applicationBadgeNumber];
    }
 
    
    return YES;
}

- (void)makeRootController
{
    //控制器初始化
    XWGJTabBarController *mainTabBarController  = [[XWGJTabBarController alloc] init];
    self.mainTabBarController = mainTabBarController;
    XWGJLeftMenuViewController *leftMenuViewController = [[XWGJLeftMenuViewController alloc] init];
    leftMenuViewController.contentViewController = mainTabBarController;
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:mainTabBarController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    //  sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.view.backgroundColor =[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    //    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
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
        
        IntroViewController *vc = [[IntroViewController alloc] init];
        
        [self.window.rootViewController presentViewController:vc animated:NO completion:nil];
        
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
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
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

 
  
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    KDClassLog(@" didRegisterForRemoteNotificationsWithDeviceToken  %@",deviceToken);
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    KDClassLog(@"IOS <= 6   didReceiveRemoteNotification  %@",userInfo);
    // Required
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
//   LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
    NewLoginRegisterViewController *vc = [[NewLoginRegisterViewController alloc] initWithNibName:@"NewLoginRegisterViewController" bundle:nil];
    XWGJNavigationController *nav =[[XWGJNavigationController alloc] initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:nav animated:YES completion:^{}];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)isLogin {
    return _accessToken != nil;
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}



//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return  [UMSocialSnsService handleOpenURL:url];
//}


#pragma mark RESideMenu Delegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    //    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end