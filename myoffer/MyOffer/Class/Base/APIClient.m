//
//  APIClient.m
//  Kata
//
//  Created by Blankwonder on 2/4/15.
//  Copyright (c) 2015 Daxiang. All rights reserved.
//

#import "APIClient.h"
#import <sys/utsname.h>

NSString * const kAPIClientErrorDomain = @"kAPIClientErrorDomain";

@interface APIClient () <NSURLSessionDataDelegate> {
    NSURLSession *_URLSession;
    NSURL *_endPoint;
}

@end

static NSString * const kAPIEndPoint = DOMAINURL;

@implementation APIClient

+ (APIClient *)defaultClient {
    static dispatch_once_t pred;
    __strong static id sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        
        sharedInstance = [[APIClient alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _endPoint = [NSURL URLWithString:kAPIEndPoint];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 1;
        configuration.HTTPShouldUsePipelining = YES;
        
        NSString *bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
        bundleName = [bundleName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        
        struct utsname systemInfo;
        
        uname(&systemInfo);
        
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@ %@/%@", bundleName, version,
                               @(systemInfo.machine), [[UIDevice currentDevice] systemVersion]];
        
        
//        NSLog(@" ystemInfo.machine  %@",@(systemInfo.machine));
//ENGLISH  设置环境
//         NSString  *lan = [InternationalControl userLanguage];
//        if ( [lan containsString:@"en"]) {
//             configuration.HTTPAdditionalHeaders = @{@"User-Agent": userAgent,
//                                                    @"Accept-Charset": @"UTF-8",
//                                                    @"user-language": @"en"
//                                                    };
//        }
//        else
//          {
               configuration.HTTPAdditionalHeaders = @{@"User-Agent": userAgent,
                                                       @"Accept-Charset": @"UTF-8"
                                                      };
//         }
    
        
//        NSLog(@"HTTPAdditionalHeaders %@",configuration.HTTPAdditionalHeaders);
        
//        _URLSession = [NSURLSession sessionWithConfiguration:configuration];
        
        // 使用代理方法需要设置代理,但是session的delegate属性是只读的,要想设置代理只能通过这种方式创建session
        _URLSession = [NSURLSession sessionWithConfiguration:configuration
                                                              delegate:self
                                                         delegateQueue:[[NSOperationQueue alloc] init]];
        
        
    }
    
    
      return self;
}

- (NSURLSessionDataTask *)startTaskWithRequest:(NSURLRequest *)request
                           expectedStatusCodes:(NSArray *)expectedStatusCode
                                       success:(APIClientSuccessBlock)success
                                       failure:(APIClientFailureBlock)failure {
    if (!expectedStatusCode) {
        
        expectedStatusCode = @[@(200)];
    }

    
    if (!success) success = ^(NSInteger statusCode , NSDictionary *response) {};
    
    if (!failure) failure = ^(NSInteger statusCode , NSError *error) {};
 
    NSURLSessionDataTask * task = [_URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *_response, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)_response;
 
        if (error) {
            
            KDClassLog(@"Request failed: %@", error);
            
            dispatch_async( dispatch_get_main_queue(),^{
            
                failure(0, error);
                
            });
            
            return;
        }
        
        if (data && data.length < 1000) {
            
//            KDClassLog(@"Response body: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        KDClassLog(@"Request completed: [%d], %@", (int)response.statusCode, request.URL.absoluteString);
        
        
        
        NSError *JSONError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
      
//        KDClassLog(@"Error 这在这里测试服务器错误 error = %@  code = %d   statusCode = %d   \n path = %@  result =  %@  ",JSONError,JSONError.code,response.statusCode,request.URL.absoluteString,result);
        
        if (JSONError) {
          
            KDClassLog(@"Error occurred when json serializating: %@", JSONError);
            KDClassLog(@"JSONError 出错 = %@    response.statusCode =  %d    path = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],response.statusCode,request.URL.absoluteString);
            
            dispatch_async( dispatch_get_main_queue(),^{
                
                    failure(response.statusCode, [NSError errorWithDomain:kAPIClientErrorDomain code:kAPIClientErrorDomainCodeJSONDeserializatingError userInfo:nil]);
            });
            return;
        }
        
        if (![expectedStatusCode containsObject:@(response.statusCode)]) {
            dispatch_async( dispatch_get_main_queue(),^{
                /*
                 *  collision  : 账号合并时手机号码已存在时，出现的特殊标识  collision显示手机号码信息
                 *  error      ：后台提示错误信息
                 *  NSLog(@"%@ 失败信息解析  %@",result,[result class]);
                 */
                //失败信息解析
                
                NSString *errorStr = result[@"collision"] ? [NSString stringWithFormat:@"phone=%@",result[@"collision"]] : result[@"error"];
                
                failure(response.statusCode, [NSError errorWithDomain:kAPIClientErrorDomain
                                                                 code:kAPIClientErrorDomainCodeUnexpectedStatusMaskCode + response.statusCode
                                                             userInfo:@{@"message": errorStr}]);
            });
            return;
        }
        
        dispatch_async( dispatch_get_main_queue(),^{
            
            success(response.statusCode, result);
            
        });
        
        
    }];
    
    [task resume];
    
       KDClassLog(@"Request started: %@ ---  %@", request.HTTPMethod, request.URL.absoluteString);
    if (request.HTTPBody) {
        KDClassLog(@"Request body: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    }
    
    
    return task;
}

- (NSURLSessionDataTask *)startTaskWithMethod:(NSString *)method
                                         path:(NSString *)path
                                   parameters:(NSDictionary *)parameters
                          expectedStatusCodes:(NSArray *)expectedStatusCode
                                      success:(APIClientSuccessBlock)success
                                      failure:(APIClientFailureBlock)failure {
    
    __block NSString *newPath = path;


    if ([parameters isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *newParameters = [NSMutableDictionary dictionary];
 
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            
             if ([key hasPrefix:@":"]) {
                 
 
                newPath = [path stringByReplacingOccurrencesOfString:key withString:[self encodedString:obj]];


            } else {
                
                newParameters[key] = obj;
            }
        }];
        
        parameters = newParameters;
    }
 
 
    NSURL *url =[NSURL URLWithString:newPath relativeToURL:_endPoint];

    if([newPath hasPrefix:@"http"]){
        url =[NSURL URLWithString:newPath];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    request.timeoutInterval = 15;
    
    if ([method isEqualToString:@"GET"] ||
        [method isEqualToString:@"HEAD"] ||
        [method isEqualToString:@"DELETE"]) {
        if (parameters.count > 0) {
            NSMutableArray *pairs = [NSMutableArray arrayWithCapacity:parameters.count];
            [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *encodedKey = [self encodedString:key];
                NSString *encodedValue = [self encodedString:obj];
                [pairs addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
            }];
            NSString *query = [pairs componentsJoinedByString:@"&"];
            url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:@"?%@", query]];
            [request setURL:url];
        }
    } else {
        NSError *error;
        if (!parameters) {
            parameters = @{};
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        if (!data) {
            KDClassLog(@"Error occurred when json serializating: %@", error);
            return nil;
        }
        
        [request setHTTPBody:data];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
 
     if (LOGIN) {
     
        [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
     
     }else{
         //cookie中保存了登录信息，可能会引起数据错误
         [request setValue:@"" forHTTPHeaderField:@"Cookie"];
     }
    
  
    return [self startTaskWithRequest:request expectedStatusCodes:expectedStatusCode success:success failure:failure];
    
}

- (NSString *)encodedString:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj stringValue];
    } else if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                     NULL,
                                                                                     (CFStringRef)obj,
                                                                                     NULL,
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                     kCFStringEncodingUTF8 ));
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Unknown value type"];
        return nil;
    }
}





- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    [_URLSession finishTasksAndInvalidate];
}

- (void)dealloc{

    [_URLSession invalidateAndCancel];

}




@end
