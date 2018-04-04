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
        
        _time = [NSString stringWithFormat:@"%@ —— %@",_statrTime,_endTime];
    }
    
    return _time;
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

- (BOOL)disable{
    
    return (self.state.integerValue == 2);
}

- (NSString *)imageName{
    
    if (!_imageName) {
        
        _imageName = _disabled ? @"discount_disable":@"discount_nomal";
    }
    
    return _imageName;
}


@end

