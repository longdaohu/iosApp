//
//  SMBannerModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMBannerModel.h"

@implementation SMBannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"banner_id" : @"_id"};
}

- (NSString *)image_url{
 
    return [_image_url_mc toUTF8WithString];
}

@end
