//
//  APIClient.h
//  Kata
//
//  Created by Blankwonder on 2/4/15.
//  Copyright (c) 2015 Daxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void ( ^APIClientSuccessBlock ) ( NSInteger statusCode , id response );
typedef void ( ^APIClientFailureBlock ) ( NSInteger statusCode , NSError *error );

extern NSString * const kAPIClientErrorDomain;

typedef NS_ENUM(int, kAPIClientErrorDomainCode) {
    kAPIClientErrorDomainCodeUnknown = 0,
    kAPIClientErrorDomainCodeJSONDeserializatingError = 10000,
    kAPIClientErrorDomainCodeUnexpectedStatusMaskCode = 11000
};

@interface APIClient : NSObject

+ (APIClient *)defaultClient;

- (NSURLSessionDataTask *)startTaskWithMethod:(NSString *)method
                                         path:(NSString *)path
                                   parameters:(NSDictionary *)parameters
                          expectedStatusCodes:(NSArray *)expectedStatusCode
                                      success:(APIClientSuccessBlock)success
                                      failure:(APIClientFailureBlock)failure;

- (NSURLSessionDataTask *)startTaskWithRequest:(NSURLRequest *)request
                           expectedStatusCodes:(NSArray *)expectedStatusCode
                                       success:(APIClientSuccessBlock)success
                                       failure:(APIClientFailureBlock)failure;

@end