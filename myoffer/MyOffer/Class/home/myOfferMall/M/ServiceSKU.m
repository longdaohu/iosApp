//
//  ServiceSKU.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceSKU.h"

@implementation ServiceSKU

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"service_id" : @"_id"};
    
}

-(NSString *)cover_path{
    
    
  return   [self.cover_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

- (BOOL)isZheKou{
    
    
    return  [self.price isEqualToString:self.display_price];
}


@end
