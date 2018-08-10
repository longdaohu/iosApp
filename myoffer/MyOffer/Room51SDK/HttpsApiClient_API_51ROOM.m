//
//  Created by  fred on 2016/10/26.
//  Copyright © 2016 Alibaba. All rights reserved.
//

#import "HttpsApiClient_API_51ROOM.h"

@implementation HttpsApiClient_API_51ROOM

@synthesize client,isHttps;

static NSString* HOST = @"api.51room.com";

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static HttpsApiClient_API_51ROOM *api = nil;
    dispatch_once(&onceToken, ^{
        api = [HttpsApiClient_API_51ROOM new];
    });
    return api;
}

- (instancetype)init {
    client = [[CAClient alloc] init];
    isHttps = true;
    
    return self;
}

-(void) setAppKeyAndAppSecret:(NSString*)appKey appSecret:(NSString*) appSecret{
    [client setAppKeyAndAppSecret:appKey appSecret:appSecret];
}

- (void) Search_Place:(NSInteger) countryId keywords:(NSString *) keywords completionBlock:(void (^)(CACommonResponse *))completionBlock
{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/search/place/[countryId]/[keywords]"
                                                          withMethod: @"GET"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    
    [request addPathParameter:[NSString stringWithFormat:@"%ld" , countryId] forKey:@"countryId"];
    [request addPathParameter:keywords forKey:@"keywords"];
    
    
    [client invokeWithRequest: request withCallback:completionBlock];
    
}
- (void) property:(NSInteger) property_id completionBlock:(void (^)(CACommonResponse *))completionBlock
{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/property/[property_id]"
                                                          withMethod: @"GET"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    
    [request addPathParameter:[NSString stringWithFormat:@"%ld" , property_id] forKey:@"property_id"];
    
    
    [client invokeWithRequest: request withCallback:completionBlock];
    
}
- (void) article:(NSInteger) article_id completionBlock:(void (^)(CACommonResponse *))completionBlock
{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/article/[article_id]"
                                                          withMethod: @"GET"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    
    [request addPathParameter:[NSString stringWithFormat:@"%ld" , article_id] forKey:@"article_id"];
    
    
    [client invokeWithRequest: request withCallback:completionBlock];
    
}
- (void) homepage:(NSInteger) countryId completionBlock:(void (^)(CACommonResponse *))completionBlock
{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/homepage/[countryId]"
                                                          withMethod: @"GET"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    
    [request addPathParameter:[NSString stringWithFormat:@"%ld" , countryId] forKey:@"countryId"];
    
    
    [client invokeWithRequest: request withCallback:completionBlock];
    
}
- (void) cities:(NSInteger) countryId completionBlock:(void (^)(CACommonResponse *))completionBlock
{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/cities/[countryId]"
                                                          withMethod: @"GET"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    
    [request addPathParameter:[NSString stringWithFormat:@"%ld" , countryId] forKey:@"countryId"];
    
    
    [client invokeWithRequest: request withCallback:completionBlock];
    
}

@end
