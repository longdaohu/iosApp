//
//  MyOfferAutoRunBanner.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferAutoRunBanner.h"

@implementation MyOfferAutoRunBanner
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"banner_id" : @"_id"};
    
}
- (NSString *)thumbnail{
    
    NSString *path = [_thumbnail toUTF8WithString];
    
    if (!_thumbnail) {
        path = [_cover_url toUTF8WithString];
    }
    
    return path;
}

- (NSString *)cover_url{
    
    NSString *path = [_cover_url toUTF8WithString];
 
    return path;
}

@end


