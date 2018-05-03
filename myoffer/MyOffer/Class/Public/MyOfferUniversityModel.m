//
//  MyOfferUniversityModel.m
//  myOffer
//
//  Created by xuewuguojie on 2016/10/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "MyOfferUniversityModel.h"
#import "SearchUniCourseFrame.h"

@implementation MyOfferUniversityModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"NO_id" : @"_id",
             @"NO_id" : @"id",
             @"found_year" : @"found"
             };
    
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"courses" : @"UniversityCourse",
             @"applies" : @"Applycourse"
             };
    
}


 

- (NSString *)address_long{
    
    return [NSString stringWithFormat:@"%@ | %@ | %@",self.country,self.state,self.city];
}

- (NSString *)address_short{
    
    return [NSString stringWithFormat:@"%@ | %@",self.country,self.city];
}

-(NSNumber *)ranking_qs{
 
    NSNumber *rank; //= @0 Value stored to 'rank' during its initialization is never read
    if (_ranking_qs) {
        rank = (_ranking_qs.integerValue == DEFAULT_NUMBER)? @0 : _ranking_qs;
    }else{
        rank = @0;
    }
    return rank;
    
}

-(NSNumber *)ranking_ti{
 
    NSNumber *rank;//= @0 Value stored to 'rank' during its initialization is never read
    if (_ranking_ti) {
        rank = (_ranking_ti.integerValue == DEFAULT_NUMBER)? @0 : _ranking_ti;
    }else{
        rank = @0;
    }
    return rank;
}

- (NSString *)ranking_ti_str{
    
    NSString *local_ranking_ti  = [NSString stringWithFormat:@"%@",self.ranking_ti];
    //1、澳大利亚
    if ([self.country  containsString:@"澳"]) local_ranking_ti  =  [NSString stringWithFormat:@"%@星",local_ranking_ti];
    
    NSString *rank = (self.ranking_ti.integerValue == 0 )? @"暂无排名" :local_ranking_ti;
 
    return [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rank];
}

- (NSString *)ranking_qs_str{
    
    NSString *qs_rank = (self.ranking_qs.integerValue == 0 )? @"暂无排名" : [NSString stringWithFormat:@"%@",self.ranking_qs];
 
    return [NSString stringWithFormat:@"世界排名：%@",qs_rank];
}



@end
