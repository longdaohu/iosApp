//
//  Created by  fred on 2016/10/26.
//  Copyright © 2016 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApiGatewaySdk/CAClient.h>
#import <ApiGatewaySdk/CACommonResponse.h>

@interface HttpApiClient_API_51ROOM : NSObject

{

    CAClient* client;
    bool isHttps;

}

@property (nonatomic) CAClient* client;
@property (nonatomic) bool isHttps;

+ (instancetype) instance;
- (instancetype) init;
-(void) setAppKeyAndAppSecret:(NSString*)appKey appSecret:(NSString*) appSecret;

@end