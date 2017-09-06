//
//  BaseViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/8/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"
#import "NSString+MD5.h"
#import "MyOfferLoginViewController.h"

@implementation BaseViewController {
    NSMutableArray *_APIRequestTasks;
    MBProgressHUD *_requestHUD;
    
    UITapGestureRecognizer *_endEditingTapGestureRecognizer;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [MBProgressHUD hideHUD];
    
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

        _requestHUD = [MBProgressHUD showMessage:nil toView:self.view];
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
             [_requestHUD hideAnimated:YES];
             _requestHUD = nil;
         }
         
         if (success) {
             @try {
                 success(statusCode, response);
             }
             @catch (NSException *exception) {
                 //@"服务器返回结果解析出错"
                 [KDAlertView showMessage:GDLocalizedString(@"NetRequest-SeverReturnError") cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];
             }
         }
     } failure:^(NSInteger statusCode, NSError *error) {
         
         [_APIRequestTasks removeObject:task];
        
         if (_APIRequestTasks.count == 0) {
             [_requestHUD hideAnimated:YES];
             _requestHUD = nil;
         }
         
         
         //当返回状态为401 未登录（或状态已过期），把app退出当前登录，并不返回错误提示，当做什么事也没有发生
         if (statusCode == 401) {
         
             [[AppDelegate sharedDelegate] logout];
             [[AppDelegate sharedDelegate] presentLoginAndRegisterViewControllerAnimated:YES];
         
         } else {
             
             if (showErrorAlert && error.code != kCFURLErrorCancelled) {
                 
                 //特殊处理 用户第三方登录时合并账号，如果有包含字符串
                 if (![error.userInfo[@"message"] containsString:@"phone"]) {
                 
                     [self showAPIErrorAlertView:error clickAction:errorAlertDismissAction];
                     NSLog(@"服务器错误 =  %@ ",path);

                 }
                 
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
        
        errorMessage = error.userInfo[@"message"] ?: [NSString stringWithFormat:@"服务器错误 %d",(int)error.code];//
  
     } else {
         
        errorMessage = @"网络请求失败，请检查网络连接后重试。";
    }
    
    NSString *errorTitle = @"错误";
    
    if ([[KDAlertView presentingAlertView].title isEqualToString:errorTitle] &&
        [[KDAlertView presentingAlertView].message isEqualToString:errorMessage]) {
        KDClassLog(@"Ignore duplicate message: %@", errorMessage);
        return;
    }
    
    KDAlertView *av = [[KDAlertView alloc] initWithTitle:errorTitle message:errorMessage cancelButtonTitle:GDLocalizedString(@"NetRequest-OK") cancelAction:^(KDAlertView *av){
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



-(void)viewDidLoad
{

    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    
    self.conn = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [self.conn startNotifier];
    
    self.view.backgroundColor = XCOLOR_BG;
    
}

- (void)networkStateChange
{
    [self checkNetWorkReaching];
}


-(BOOL)checkNetWorkReaching
{

    NetworkStatus status = [self.conn currentReachabilityStatus];
    KDClassLog(@"网络联接状态 %d",status == NotReachable ? NO : YES);
    return status == NotReachable ? NO : YES;
 
}


- (BOOL)checkNetworkState
{

    if (![self checkNetWorkReaching]) {
        
        AlerMessage(@"当前网络不可用，请检查网络");
        
     }

    return [self checkNetWorkReaching];
}


//登录页面
-(void)loginView{

 
    XWGJNavigationController *nav =[[XWGJNavigationController alloc] initWithRootViewController:[[MyOfferLoginViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:^{}];

}


- (void)dealloc
{
    [self.conn stopNotifier];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark : 提前加载数据，存储在本地，下次调用

- (void)baseDataSourse:(NSString *)pageStr
{
    
    NSInteger page;
    
    if ([pageStr isEqualToString:@"country"]) {
        
        page = 0;
        
    }else if([pageStr isEqualToString:@"subject"]){
    
         page = 1;
        
    }else{
    
        page = 2;
    }
    
    switch (page) {
        case 0:
            [self countryWithAlert:NO];
            break;
        case 1:
             [self subjectWithAlert:NO];
            break;
        default:
             [self gradeWithAlert:NO];
            break;
    }
    

    
}

- (void)baseDataSourse{

    [self countryWithAlert:NO];
    
    [self gradeWithAlert:NO];
    
    [self subjectWithAlert:NO];
    
}

//获取国家
- (void)countryWithAlert:(BOOL)show{
    
    [self baseDataSourseWithPath:kAPISelectorCountries  keyWord:@"Country_CN" parameters:@{@":lang":@"zh-cn"}  ErrorAlerShow:show];
    [self baseDataSourseWithPath:kAPISelectorCountries  keyWord:@"Country_EN" parameters:@{@":lang":@"en"}  ErrorAlerShow:show];
  
}

//获取专业
- (void)subjectWithAlert:(BOOL)show{
    
    [self baseDataSourseWithPath:kAPISelectorSubjects_new  keyWord:@"Subject_CN" parameters:nil  ErrorAlerShow:show];
    [self baseDataSourseWithPath:kAPISelectorSubjects  keyWord:@"Subject_EN" parameters:@{@":lang":@"en"}  ErrorAlerShow:show];
 
}

//获取年级
- (void)gradeWithAlert:(BOOL)show{
    
    [self baseDataSourseWithPath:kAPISelectorGrades  keyWord:@"Grade_CN" parameters:@{@":lang":@"zh-cn"}  ErrorAlerShow:show];
    [self baseDataSourseWithPath:kAPISelectorGrades  keyWord:@"Grade_EN" parameters:@{@":lang":@"en"}  ErrorAlerShow:show];
    
}


-(void)baseDataSourseWithPath:(NSString *)path  keyWord:(NSString *)keyWord  parameters:(NSDictionary *)para  ErrorAlerShow:(BOOL)show{
    
    NSUserDefaults *ud  = [NSUserDefaults  standardUserDefaults];

//    [self startAPIRequestUsingCacheWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
//       
//        [ud setValue:response forKey:keyWord];
//        
//        [ud synchronize];
//        
//    }];
   
    [self startAPIRequestWithSelector:path  parameters:para expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [ud setValue:response forKey:keyWord];
        
        [ud synchronize];
        
     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         NSLog(@"服务器错误 = %@  %ld",path ,(long)statusCode);

        if (show) {
            
            
           AlerMessage(@"网络请求失败");
            
        }
        
    }];

    
}



@end
