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
#import "CategoryViewController.h"
#import "EvaluateViewController.h"
#import "MeViewController.h"
#import "IntroViewController.h"
#import "UserDefaults.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "NewLoginRegisterViewController.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "DEMOLeftMenuViewController.h"


@interface AppDelegate ()<RESideMenuDelegate>
{
    NSString *_accessToken;
 }

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
 

    XWGJTabBarController *mainTabBarController  = [[XWGJTabBarController alloc] init];
    
    DEMOLeftMenuViewController *leftMenuViewController = [[DEMOLeftMenuViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:mainTabBarController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
//    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.view.backgroundColor =[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    [self.window makeKeyAndVisible];
     NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
    if (![[UserDefaults sharedDefault].introductionDismissBuildVersion isEqualToString:version]) {

        IntroViewController *vc = [[IntroViewController alloc] init];
        [self.xtabBarController presentViewController:vc animated:NO completion:nil];
        [UserDefaults sharedDefault].introductionDismissBuildVersion = version;
    }
    
    [self umeng];
    
    return YES;
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
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


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