//
//  BaseViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/8/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APIClient.h"
#import "APIClient+Interface.h"
#import "Reachability.h"

@interface BaseViewController : UIViewController

- (void)startAPIRequestUsingCacheWithSelector:(NSString *)selector
                                   parameters:(NSDictionary *)parameters
                                      success:(APIClientSuccessBlock)success;

- (void)startAPIRequestWithSelector:(NSString *)selector
                         parameters:(NSDictionary *)parameters
                            success:(APIClientSuccessBlock)success;

- (void)startAPIRequestWithSelector:(NSString *)selector
                         parameters:(NSDictionary *)parameters
                            showHUD:(BOOL)showHUD
                            success:(APIClientSuccessBlock)success;

- (void)startAPIRequestWithSelector:(NSString *)selector
                         parameters:(NSDictionary *)parameters
                            showHUD:(BOOL)showHUD
            errorAlertDismissAction:(void (^)())errorAlertDismissAction
                            success:(APIClientSuccessBlock)success;

- (void)startAPIRequestWithSelector:(NSString *)selector
                         parameters:(NSDictionary *)parameters
                expectedStatusCodes:(NSArray *)expectedStatusCode
                            showHUD:(BOOL)showHUD
                     showErrorAlert:(BOOL)showErrorAlert
            errorAlertDismissAction:(void (^)())errorAlertDismissAction
            additionalSuccessAction:(APIClientSuccessBlock)success
            additionalFailureAction:(APIClientFailureBlock)failure;

- (void)showAPIErrorAlertView:(NSError *)error clickAction:(void (^)())action;

@property (nonatomic) BOOL tapToEndEditing;
@property (nonatomic,assign) BOOL newWorkReach;
@property (nonatomic, strong) Reachability *conn;
- (IBAction)endEditing;
- (IBAction)dismiss;

@property (copy, nonatomic) void (^dismissCompletion)(BaseViewController *vc);

- (BOOL)checkNetWorkReaching;
- (BOOL)checkNetworkState;
- (void)loginView;
- (void)baseDataSourse;
- (void)baseDataSourse:(NSString *)pageStr;

@end
