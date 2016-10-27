//
//  UniversityItemNew.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityItemNew.h"

@implementation UniversityItemNew
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NO_id" : @"_id",@"found_year" : @"found"};
    
}

- (NSString *)address_detail{
    
    return [NSString stringWithFormat:@"%@ | %@ | %@",self.country,self.state,self.city];
}

- (NSString *)address_short{
    
    return [NSString stringWithFormat:@"%@ | %@",self.country,self.city];
}

-(NSNumber *)ranking_qs{

    
    return _ranking_qs ? _ranking_qs : @DefaultNumber;
}


-(NSNumber *)ranking_ti{
    
    
    return _ranking_ti ? _ranking_ti : @DefaultNumber;
}


@end
