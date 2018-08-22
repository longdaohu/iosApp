//
//  HomeRoomIndexFlatsObject.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomIndexFlatsObject.h"

@implementation HomeRoomIndexFlatsObject
- (NSString *)image{
    
    if (!_image) {
        _image = [self.pic valueForKeyPath:@"url"];
    }
    
    return _image;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"no_id" : @"id"
             };
}

- (NSAttributedString *)priceAttribue{
    
    if (!_priceAttribue) {
        
        NSString *a = [NSString stringWithFormat:@"%@%@",self.currency,self.rent];
        NSString *b = [NSString stringWithFormat:@"%@",self.unit];
        NSString *path  = [NSString stringWithFormat:@"%@%@",a,b];
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:path];
        [att addAttributes:@{
                             NSForegroundColorAttributeName : XCOLOR_RED
                             } range:NSMakeRange(0, a.length)];
        
        _priceAttribue = [[NSAttributedString alloc] initWithAttributedString:att];
     }
 
    return _priceAttribue;
}

- (NSString *)thumb{
    
    if (!_thumb) {
        _thumb = [self.thumbnail toUTF8WithString];
    }
    
    return _thumb;
}




@end
