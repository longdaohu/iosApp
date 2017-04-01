//
//  ServiceItem.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItem.h"
//#import "ServiceProtocalItem.h"

@implementation ServiceItem

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"agreements" : @"ServiceProtocalItem"};
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


@end
