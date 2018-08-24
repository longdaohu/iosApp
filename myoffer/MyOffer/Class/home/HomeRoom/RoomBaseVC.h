//
//  RoomBaseVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomBaseVC : UIViewController

- (void)cities:(NSInteger)countryCode showHUD:(BOOL)showHUD additionalSuccessAction:(void(^)(id response,int status))success additionalFailureAction:(void(^)(NSError *error,int status))failure;

- (void)property_listWhithParameters:(NSDictionary *)parameter  additionalSuccessAction:(void(^)(id response,int status))success additionalFailureAction:(void(^)(NSError *error,int status))failure;

- (void)propertyWithRoomID:(NSInteger )room_id  additionalSuccessAction:(void(^)(id response,int status))success additionalFailureAction:(void(^)(NSError *error,int status))failure;

- (void)enquiryWithParameter:(NSDictionary *)parameter additionalSuccessAction:(void(^)(id response,int status))success additionalFailureAction:(void(^)(NSError *error,int status))failure;


@end

