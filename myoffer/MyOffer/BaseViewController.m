//
//  BaseViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/8/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"
#import "KDProgressHUD.h"
#import "NSString+MD5.h"

@implementation BaseViewController {
    NSMutableArray *_APIRequestTasks;
    KDProgressHUD *_requestHUD;
    
    UITapGestureRecognizer *_endEditingTapGestureRecognizer;
}

- (void)startAPIRequestWithSelector:(NSString *)selector
                         parameters:(NSDictionary *)parameters
                expectedStatusCodes:(NSArray *)expectedStatusCode
                            showHUD:(BOOL)showHUD
                     showErrorAlert:(BOOL)showErrorAlert
            errorAlertDismissAction:(void (^)())errorAlertDismissAction
            additionalSuccessAction:(APIClientSuccessBlock)success
            additionalFailureAction:(APIClientFailureBlock)failure {
    if (!_APIRequestTasks) {
        _APIRequestTasks = [NSMutableArray array];
    }
    
    if (!_requestHUD && showHUD) {
        _requestHUD = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
    }
        
    NSArray *comps = [selector componentsSeparatedByString:@" "];
    NSString *method = comps[0];
    __block NSString *path = comps[1];
    
    __block NSURLSessionDataTask *task =
    [[APIClient defaultClient]
     startTaskWithMethod:method
     path:path
     parameters:parameters
     expectedStatusCodes:expectedStatusCode
     success:^(NSInteger statusCode, NSDictionary *response) {
         [_APIRequestTasks removeObject:task];
         if (_APIRequestTasks.count == 0) {
             [_requestHUD hideAnimated:NO];
             _requestHUD = nil;
         }
         
         if (success) {
             @try {
                 success(statusCode, response);
             }
             @catch (NSException *exception) {
                 [KDAlertView showMessage:@"服务器返回结果解析出错" cancelButtonTitle:@"好的"];
             }
         }
     } failure:^(NSInteger statusCode, NSError *error) {
         [_APIRequestTasks removeObject:task];
         if (_APIRequestTasks.count == 0) {
             [_requestHUD hideAnimated:NO];
             _requestHUD = nil;
         }
         
         if (statusCode == 401) {
             [[AppDelegate sharedDelegate] logout];
             [[AppDelegate sharedDelegate] presentLoginAndRegisterViewControllerAnimated:YES];
         } else {
             if (showErrorAlert && error.code != kCFURLErrorCancelled) {
                 [self showAPIErrorAlertView:error clickAction:errorAlertDismissAction];
             }
         }
         
         if (failure) failure(statusCode, error);
     }];
    
    [_APIRequestTasks addObject:task];
}

- (void)startAPIRequestUsingCacheWithSelector:(NSString *)selector
                                   parameters:(NSDictionary *)parameters
                                      success:(APIClientSuccessBlock)success{
    NSString *key = [NSString stringWithFormat:@"%@\n%@", selector, parameters.KD_JSONString];
    key = [key KD_MD5];
    
    id cachedResult = [KDStroageHelper dataFromLibraryWithIdentifier:key].KD_JSONObject;
    if (cachedResult) {
        success(-1, cachedResult);
    }
    
    [self startAPIRequestWithSelector:selector
                           parameters:parameters
                  expectedStatusCodes:nil
                              showHUD:[cachedResult count] == 0
                       showErrorAlert:YES
              errorAlertDismissAction:nil
              additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [KDStroageHelper writeDataToLibrary:[response KD_JSONData] identifier:key];
                  success(statusCode, response);
              }
              additionalFailureAction:nil];
}

- (void)startAPIRequestWithSelector:(NSString *)selector
                         parameters:(NSDictionary *)parameters
                            success:(APIClientSuccessBlock)success{
    [self startAPIRequestWithSelector:selector
                           parameters:parameters
                  expectedStatusCodes:nil
                              showHUD:YES
                       showErrorAlert:YES
              errorAlertDismissAction:nil
              additionalSuccessAction:success
              additionalFailureAction:nil];
}

- (void)startAPIRequestWithSelector:(NSString *)selector
                         parameters:(NSDictionary *)parameters
                            showHUD:(BOOL)showHUD
                            success:(APIClientSuccessBlock)success {
    [self startAPIRequestWithSelector:selector
                           parameters:parameters
                  expectedStatusCodes:nil
                              showHUD:showHUD
                       showErrorAlert:YES
              errorAlertDismissAction:nil
              additionalSuccessAction:success
              additionalFailureAction:nil];
}

- (void)startAPIRequestWithSelector:(NSString *)selector
                         parameters:(NSDictionary *)parameters
                            showHUD:(BOOL)showHUD
            errorAlertDismissAction:(void (^)())errorAlertDismissAction
                            success:(APIClientSuccessBlock)success{
    [self startAPIRequestWithSelector:selector
                           parameters:parameters
                  expectedStatusCodes:nil
                              showHUD:showHUD
                       showErrorAlert:YES
              errorAlertDismissAction:errorAlertDismissAction
              additionalSuccessAction:success
              additionalFailureAction:nil];
}

- (void)showAPIErrorAlertView:(NSError *)error clickAction:(void (^)())action {
    NSString *errorMessage;
    if (error.domain == kAPIClientErrorDomain) {
        errorMessage = error.userInfo[@"message"] ?: [NSString stringWithFormat:@"服务器错误 %d", (int)error.code];
    } else {
        errorMessage = @"网络请求失败，请检查网络连接后重试。";
    }
    
    NSString *errorTitle = @"错误";
    
    if ([[KDAlertView presentingAlertView].title isEqualToString:errorTitle] &&
        [[KDAlertView presentingAlertView].message isEqualToString:errorMessage]) {
        KDClassLog(@"Ignore duplicate message: %@", errorMessage);
        return;
    }
    
    KDAlertView *av = [[KDAlertView alloc] initWithTitle:errorTitle message:errorMessage cancelButtonTitle:@"好的" cancelAction:^(KDAlertView *av){
            if (action) {
                action();
            }
        }];
    
    [av show];
}

- (void)setTapToEndEditing:(BOOL)tapToEndEditing {
    if (_tapToEndEditing != tapToEndEditing) {
        _tapToEndEditing = tapToEndEditing;
        if (tapToEndEditing) {
            _endEditingTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
            [self.view addGestureRecognizer:_endEditingTapGestureRecognizer];
        } else {
            [self.view removeGestureRecognizer:_endEditingTapGestureRecognizer];
            _endEditingTapGestureRecognizer = nil;
        }
    }
}

- (void)endEditing {
    [self.view endEditing:NO];
}

- (IBAction)dismiss {
    if (self.navigationController &&
        self.navigationController.viewControllers.count > 1 &&
        self.navigationController.viewControllers.lastObject == self) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.dismissCompletion) {
            self.dismissCompletion(self);
            self.dismissCompletion = nil;
            return;
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.dismissCompletion) {
                self.dismissCompletion(self);
                self.dismissCompletion = nil;
                return;
            }
        }];
    }
}

- (void)cancelAllAPIRequest {
    for (NSURLSessionDataTask *task in _APIRequestTasks) {
        [task cancel];
    }
    [_APIRequestTasks removeAllObjects];
}

@end
