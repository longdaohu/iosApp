//
//  UniversityNew.m
//  myOffer
//
//  Created by xuewuguojie on 2016/10/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityNew.h"

@implementation UniversityNew
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NO_id" : @"_id",@"found_year" : @"found"};
    
}

- (NSString *)address_long{
    
    return [NSString stringWithFormat:@"%@ | %@ | %@",self.country,self.state,self.city];
}

- (NSString *)address_short{
    
    return [NSString stringWithFormat:@"%@ | %@",self.country,self.city];
}

-(NSNumber *)ranking_qs{
    
    
    return _ranking_qs ? _ranking_qs : @DEFAULT_NUMBER;
}


-(NSNumber *)ranking_ti{
    
    
    return _ranking_ti ? _ranking_ti : @DEFAULT_NUMBER;
}
@end
