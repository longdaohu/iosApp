//
//  Created by  fred on 2016/10/26.
//  Copyright © 2016 Alibaba. All rights reserved.
//

#import "HttpApiClient_API_51ROOM.h"

@implementation HttpApiClient_API_51ROOM

@synthesize client,isHttps;

static NSString* HOST = @"api.51room.com";

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static HttpApiClient_API_51ROOM *api = nil;
    dispatch_once(&onceToken, ^{
        api = [HttpApiClient_API_51ROOM new];
    });
    return api;
}

- (instancetype)init {
    client = [[CAClient alloc] init];
    isHttps = false;
    return self;
}

-(void) setAppKeyAndAppSecret:(NSString*)appKey appSecret:(NSString*) appSecret{
    [client setAppKeyAndAppSecret:appKey appSecret:appSecret];
}



@end