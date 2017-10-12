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
 
    if (!self.display_price) {
        
        return  NO;
        
    }else{
        
        if (self.display_price.integerValue == 0) {
            
            return NO;
            
        }else{
           
            return  [self.price isEqualToString: self.display_price] ? NO : YES;

        }
 
    }
}

- (NSString *)price_str{
    
    return [self fomatterWithPrice:self.price];
}

- (NSString *)display_price_str{
    
    return [self fomatterWithPrice:self.display_price];
}

- (NSString *)fomatterWithPrice:(NSString *)price{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSNumber *number = [NSNumber numberWithFloat:price.floatValue];
    NSString *numberString = [numberFormatter stringFromNumber: number];
 
    return  [NSString stringWithFormat:@"￥ %@",numberString];
}




@end
