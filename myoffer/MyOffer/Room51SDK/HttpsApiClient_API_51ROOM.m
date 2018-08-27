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


- (void) enquiry:(void (^)(CACommonResponse *))completionBlock
{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/enquiry"
                                                          withMethod: @"POST"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    
    
    [client invokeWithRequest: request withCallback:completionBlock];
}

- (void) enquiryWithParameter:(NSDictionary *)parameter  completion:(void (^)(CACommonResponse *))completionBlock
{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/enquiry"
                                                          withMethod: @"GET"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    for (NSString *key in parameter.allKeys) {
       [request addQueryParameter:parameter[key]  forKey:key];
    }
    [client invokeWithRequest: request withCallback:completionBlock];
}

/*
 [request setHTTPBody:data];
 [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
 */

- (void) property_list:(NSInteger) page pagesize:(NSInteger) pagesize lease:(NSInteger) lease min:(NSString *) min max:(NSString *) max type:(NSString *) type type_id:(NSInteger) type_id completionBlock:(void (^)(CACommonResponse *))completionBlock
{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/propertyList/[page]/[pagesize]"
                                                          withMethod: @"GET"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    
    [request addPathParameter:[NSString stringWithFormat:@"%ld" , page] forKey:@"page"];
    [request addPathParameter:[NSString stringWithFormat:@"%ld" , pagesize] forKey:@"pagesize"];
    [request addQueryParameter:[NSString stringWithFormat:@"%ld" , lease] forKey:@"lease"];
    [request addQueryParameter:min forKey:@"min"];
    [request addQueryParameter:max forKey:@"max"];
    [request addQueryParameter:type forKey:@"type"];
    [request addQueryParameter:[NSString stringWithFormat:@"%ld" , type_id] forKey:@"type_id"];
    
    
    [client invokeWithRequest: request withCallback:completionBlock];
    
}

- (void) property_listWhithParameters:(NSDictionary *)parameter completionBlock:(void (^)(CACommonResponse *))completionBlock{
    
    CACommonRequest* request = [[CACommonRequest alloc] initWithPath: @"/propertyList/[page]/[pagesize]"
                                                          withMethod: @"GET"
                                                            withHost: HOST
                                                             isHttps: isHttps];
    for (NSString *key in parameter.allKeys) {
        if([key isEqualToString:@"page"] || [key isEqualToString:@"pagesize"] ){
            [request addPathParameter:parameter[key]  forKey:key];
        }else{
            [request addQueryParameter:parameter[key]  forKey:key];
        }
    }
    [client invokeWithRequest: request withCallback:completionBlock];
}


@end
