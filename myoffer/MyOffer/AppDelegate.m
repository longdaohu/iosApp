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
#import "LoginAndRegisterViewController.h"
#import "IntroViewController.h"
#import "UserDefaults.h"
#import "NewVersionView.h"

@interface AppDelegate ()
{
    NSString *_accessToken;
    NewVersionView *_notiView;
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
    [self compareVersionWithAPPStoreVersion];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    DiscoverViewController *dvc = [[DiscoverViewController alloc] init];
    dvc.title = @"发现";
    dvc.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    CategoryViewController *cvc = [[CategoryViewController alloc] init];
    cvc.title = @"分类";
    cvc.tabBarItem.image = [UIImage imageNamed:@"tabbar_category"];
    EvaluateViewController *evc = [[EvaluateViewController alloc] init];
    evc.title = @"评估";
    evc.tabBarItem.image = [UIImage imageNamed:@"tabbar_evaluate"];
    MeViewController *mvc = [[MeViewController alloc] initWithNibName:NSStringFromClass([MeViewController class]) bundle:nil];
    mvc.title = @"我";
    mvc.tabBarItem.image = [UIImage imageNamed:@"tabbar_me"];
    
    tabBarController.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:dvc],
                                         [[UINavigationController alloc] initWithRootViewController:cvc],
                                         [[UINavigationController alloc] initWithRootViewController:evc],
                                         [[UINavigationController alloc] initWithRootViewController:mvc]];
    
    _tabBarController = tabBarController;
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
    if (![[UserDefaults sharedDefault].introductionDismissBuildVersion isEqualToString:version]) {

        IntroViewController *vc = [[IntroViewController alloc] init];
        [tabBarController presentViewController:vc animated:NO completion:nil];
        
        [UserDefaults sharedDefault].introductionDismissBuildVersion = version;
    }
    
    return YES;
}




- (void)presentLoginAndRegisterViewControllerAnimated:(BOOL)animated {
    LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
    [self.window.rootViewController presentViewController:vc animated:YES completion:^{}];
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


//该方法用于当前用户使用版本与APPstore上的版本对比，当前版本小于APPstore的版本时强制更新
-(void)compareVersionWithAPPStoreVersion
{

    // 1. APPSTROE上应用对应的URL
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/lookup?id=1016290891"];
    
    // 2. 由session发起任务
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // 反序列化
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSArray *infoArray = [result objectForKey:@"results"];
        NSDictionary *infoDic = infoArray.firstObject;
        NSString *appStoreVersion = [infoDic objectForKey:@"version"];
        NSString *appStoreNum =  [appStoreVersion  stringByReplacingOccurrencesOfString:@"." withString:@""];

        
        // 在主线程显示相应效果
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *infoPlistDic  =[[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoPlistDic objectForKey:@"CFBundleShortVersionString"];
            NSString *currentNum  = [currentVersion  stringByReplacingOccurrencesOfString:@"." withString:@""];

            
            if ([currentNum integerValue] - [appStoreNum integerValue] < 0)
            {
        
                NewVersionView *notiView = [[NSBundle mainBundle] loadNibNamed:@"NewVersionView" owner:nil options:nil].lastObject;
                notiView.frame = CGRectMake(0.5*(APPSIZE.width - 250), 200, 250, 150);
                notiView.layer.cornerRadius = 10;
                notiView.clipsToBounds = YES;

                UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPSIZE.width, APPSIZE.height)];
                backView.backgroundColor =[UIColor blackColor];
                backView.alpha = 0.3;

                [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:backView];
                [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:notiView];
            }

        });
        
    }] resume];

}

@end