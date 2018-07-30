//
//  HomeBannerObject.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeBannerObject.h"

@implementation HomeBannerObject

- (NSString *)image{
    
    if (!_image) {
    
//        NSString *url = @"";
        NSDictionary *app = self.images[@"app"];
        _image = app[@"url"];//[url toUTF8WithString];
    }
    
    return _image;
}

- (NSString *)target{
    
    if (!_target) {
        
        NSDictionary *app = self.images[@"app"];
        _target = app[@"target"];
    }
    
    return _target;
}

@end
