//
//  ServiceItem.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItem.h"

@implementation ServiceItem

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"agreements" : @"ServiceProtocalItem",@"attributes" : @"ServiceItemAttribute"};
}


- (NSString *)peopleDisc{
    
    NSString *item = self.comment_suit_people[@"value"];

    return item;
}

- (NSString *)presentDisc{
    
    
    NSString *item = self.comment_present[@"value"];

    
    return item;
}

- (NSDictionary *)serviceType_Attibute{

    
    NSDictionary *serviceType;
    
    for (NSDictionary *attribute in self.attributes) {
        
        if ([attribute[@"key"] isEqualToString:@"类别"]) {
            
            serviceType = attribute;
            
            break;
        }
    }
    
    return serviceType;
}

- (NSDictionary *)country_Attibute{
    
    NSDictionary *country;
    
    for (NSDictionary *attribute in self.attributes) {
        
        if ([attribute[@"key"] isEqualToString:@"国家"]) {
            
            country = attribute;
            
            break;
        }
    }
    
    return country;
}


- (NSString *)price_str{
    
    return [self fomatterWithPrice:self.price];
}

- (NSString *)display_price_str{
    
    return [self fomatterWithPrice:self.display_price];
}

- (BOOL)isZheKou{
    
    if (!self.display_price) {
        
        return  NO;
        
    }else{
        
        if (self.display_price.integerValue == 0) {
            
            return NO;
            
        }else{
            
            return  (self.price.integerValue == self.display_price.integerValue) ? NO : YES;
            
        }
        
    }
}


- (NSString *)fomatterWithPrice:(NSNumber *)price{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber: price];
    
    NSString *final_Str = [NSString stringWithFormat:@"￥ %@",numberString];
    
    return  final_Str;
}



@end
