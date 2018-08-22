//
//  Created by  fred on 2016/10/26.
//  Copyright © 2016 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApiGatewaySdk/CAClient.h>
#import <ApiGatewaySdk/CACommonResponse.h>

@interface HttpsApiClient_API_51ROOM : NSObject
{
    
    CAClient* client;
    bool isHttps;
    
}

@property (nonatomic) CAClient* client;
@property (nonatomic) bool isHttps;

+ (instancetype) instance;
- (instancetype) init;
-(void) setAppKeyAndAppSecret:(NSString*)appKey appSecret:(NSString*) appSecret;

- (void) Search_Place:(NSInteger) countryId keywords:(NSString *) keywords completionBlock:(void (^)(CACommonResponse *))completionBlock;
- (void) property:(NSInteger) property_id completionBlock:(void (^)(CACommonResponse *))completionBlock;
- (void) article:(NSInteger) article_id completionBlock:(void (^)(CACommonResponse *))completionBlock;
- (void) homepage:(NSInteger) countryId completionBlock:(void (^)(CACommonResponse *))completionBlock;
- (void) cities:(NSInteger) countryId completionBlock:(void (^)(CACommonResponse *))completionBlock;
- (void) enquiry:(void (^)(CACommonResponse *))completionBlock;

- (void) property_list:(NSInteger) page pagesize:(NSInteger) pagesize lease:(NSInteger) lease min:(NSString *) min max:(NSString *) max type:(NSString *) type type_id:(NSInteger) type_id completionBlock:(void (^)(CACommonResponse *))completionBlock;
- (void) property_listWhithParameters:(NSDictionary *)parameter completionBlock:(void (^)(CACommonResponse *))completionBlock;


@end

