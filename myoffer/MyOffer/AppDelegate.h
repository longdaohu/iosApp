//
//  AppDelegate.h
//  MyOffer
//
//  Created by Blankwonder on 6/6/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)sharedDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (readonly) UITabBarController *tabBarController;

- (void)presentLoginAndRegisterViewControllerAnimated:(BOOL)animated;

- (BOOL)isLogin;
- (void)loginWithAccessToken:(NSString *)token;
- (void)logout;
- (NSString *)accessToken;

@end


#define RequireLogin if (![AppDelegate sharedDelegate].isLogin) { [[AppDelegate sharedDelegate] presentLoginAndRegisterViewControllerAnimated:YES]; return;}