//
//  AppDelegate.h
//  MyOffer
//
//  Created by Blankwonder on 6/6/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWGJTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)sharedDelegate;

@property (strong, nonatomic) UIWindow *window;
//@property (readonly) UITabBarController *tabBarController;
@property (strong,nonatomic) XWGJTabBarController *xtabBarController;
- (void)presentLoginAndRegisterViewControllerAnimated:(BOOL)animated;

- (BOOL)isLogin;
- (void)loginWithAccessToken:(NSString *)token;
- (void)logout;
- (NSString *)accessToken;
- (void)updateUmeng;
-(void)umeng;

@end


