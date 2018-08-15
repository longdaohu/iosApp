//
//  RoomTypeBookItemModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomTypeBookItemModel.h"

@implementation RoomTypeBookItemModel

- (NSString *)priceCurrency{
    
    if (!_priceCurrency) {
        _priceCurrency = [NSString stringWithFormat:@"%@ %@",self.currency,self.price];
      }
    
    return _priceCurrency;
}

- (NSString *)currentState{
    
    if (!_currentState) {
        
        NSString *state_str = [NSString stringWithFormat:@"%@",self.state];
        _currentState = [state_str isEqualToString:@"1"] ? @"满房":@"热订中";
    }
    
    return _currentState;
}


@end


