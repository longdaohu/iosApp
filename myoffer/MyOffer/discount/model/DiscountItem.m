//
//  DiscountItem.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/2.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "DiscountItem.h"

@implementation DiscountItem


- (NSString *)time{
    
    if (!_time) {
        
        _time = [NSString stringWithFormat:@"%@ — %@",self.statrTime,self.endTime];
    }
    
    return _time;
}


- (NSString *)statrTime{
    
    return [self changeWithUrl:_statrTime];

}

- (NSString *)endTime{
    
    return [self changeWithUrl:_endTime];
}

- (NSString *)changeWithUrl:(NSString *)url{
    
    NSString *path = @"";
    if (url.length == 0) {
        return path;
    }
    
    NSArray *items = [url componentsSeparatedByString:@" "];
    if (items.count > 0) {
        path = items.firstObject;
        path = [path stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    return path;
}


- (NSAttributedString *)attriPrice{
    
    if (!_attriPrice) {
        
        NSString *price =  [NSString stringWithFormat:@"￥%@",_rules];
        NSMutableAttributedString *price_attr = [[NSMutableAttributedString alloc] initWithString:price];
        [price_attr addAttribute:NSFontAttributeName value:XFONT(XFONT_SIZE(16)) range: NSMakeRange (0, 1)];
        _attriPrice =  price_attr;
    }
    return _attriPrice;
}
 
- (BOOL)disabled{
 
    return (self.state.integerValue == 2) ? YES : NO;
}

- (NSString *)imageName{
    
    if (!_imageName) {
        
        _imageName = (self.state.integerValue == 2)  ? @"discount_disable":@"discount_nomal";
        
    }

    return _imageName;
}


@end

