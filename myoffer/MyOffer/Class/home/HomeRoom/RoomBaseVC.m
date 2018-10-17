//
//  RoomBaseVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomBaseVC.h"
#import "HttpsApiClient_API_51ROOM.h"

@interface RoomBaseVC ()
@property(nonatomic,strong) MBProgressHUD *requestHUD;

@end

@implementation RoomBaseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NavigationBarHidden(NO);
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MBProgressHUD hideHUD];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = XCOLOR_BG;
}

- (void)makeHUD{
    
    self.requestHUD  = [MBProgressHUD showMessage:@"" toView:self.view];
 }

- (void)cities:(NSInteger)countryCode showHUD:(BOOL)showHUD additionalSuccessAction:(void (^)(id, int))success additionalFailureAction:(void (^)(NSError *, int))failure{
    
    if(showHUD){
        [self makeHUD];
    }
    WeakSelf
    [[HttpsApiClient_API_51ROOM instance] cities:countryCode completionBlock:^(CACommonResponse *response) {
        [weakSelf.requestHUD hideAnimated:YES];
        weakSelf.requestHUD = nil;
        [weakSelf resultWithResponse:response additionalSuccessAction:success additionalFailureAction:failure];
    }];
}


- (void)property_listWhithParameters:(NSDictionary *)parameter progressHub:(BOOL)showHub additionalSuccessAction:(void (^)(id, int ))success additionalFailureAction:(void (^)(NSError *, int ))failure{
    
    if (showHub) {
        [self makeHUD];
    }
    WeakSelf
    [[HttpsApiClient_API_51ROOM instance] property_listWhithParameters:parameter  completionBlock:^(CACommonResponse *response) {
        [weakSelf resultWithResponse:response additionalSuccessAction:success additionalFailureAction:failure];
    }];
        
}

- (void)propertyWithRoomID:(NSInteger )room_id  additionalSuccessAction:(void(^)(id response,int status))success additionalFailureAction:(void(^)(NSError *error,int status))failure{
    
    [self makeHUD];
    
    WeakSelf
    [[HttpsApiClient_API_51ROOM instance] property:room_id completionBlock:^(CACommonResponse *response) {
        [weakSelf resultWithResponse:response additionalSuccessAction:success additionalFailureAction:failure];
    }];
}

- (void)enquiryWithParameter:(NSDictionary *)parameter additionalSuccessAction:(void(^)(id response,int status))success additionalFailureAction:(void(^)(NSError *error,int status))failure{
    
    [self makeHUD];
    WeakSelf
    [[HttpsApiClient_API_51ROOM instance] enquiryWithParameter:parameter completion:^(CACommonResponse *response) {
        [weakSelf resultWithResponse:response additionalSuccessAction:success additionalFailureAction:failure];
    }];
}

- (void)resultWithResponse:(CACommonResponse *)response additionalSuccessAction:(void(^)(id response,int status))success additionalFailureAction:(void(^)(NSError *error,int status))failure{
    
    
    [self.requestHUD hideAnimated:YES afterDelay:0.5];
    if (response.statusCode != KEY_NOMAL_STUTAS) {
        if (failure) {
            [MBProgressHUD showMessage:@"网络请求错误"];
            failure(response.error,response.statusCode);
        }
        return ;
    }
    id result = [response.body KD_JSONObject];
    if (success) {
        success(result,response.statusCode);
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
