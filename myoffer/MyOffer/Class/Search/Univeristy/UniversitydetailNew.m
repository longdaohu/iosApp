//
//  UniversityNew.m
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "UniversitydetailNew.h"

@implementation UniversitydetailNew
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NO_id" : @"_id"};
    
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"global_rank_history" : @"UniversityDetailRank",
             @"local_rank_history" : @"UniversityDetailRank",
             @"rankNeighbour" : @"MyOfferUniversityModel",
             @"relate_articles" : @"MyOfferArticle"
             };
}


- (NSString *)address_long{
    
    return [NSString stringWithFormat:@"%@ | %@ | %@",self.country,self.state,self.city];
}

- (NSString *)address_short{
    
    return [NSString stringWithFormat:@"%@ | %@",self.country,self.city];
}

- (NSString *)webpath{
    
    NSString *path = self.website;
    
    if ([self.website containsString:@"www"]) {
    
        NSRange wRange = [self.website rangeOfString:@"www"];
        
        path =  [self.website substringWithRange:NSMakeRange(wRange.location, self.website.length - wRange.location)];
    
    }
    
    return path;
}


- (NSString *)ranking_ti_str{
    
    NSString *local_ranking_ti  = [NSString stringWithFormat:@"%@",self.ranking_ti];
    
    //1、澳大利亚
    if ([self.country  containsString:@"澳"]) local_ranking_ti  =  [NSString stringWithFormat:@"%@星",local_ranking_ti];
    
     NSString *ti_rank = self.ranking_ti.integerValue == DEFAULT_NUMBER ? @"暂无排名" :local_ranking_ti;
    
    return ti_rank;
}

- (NSString *)ranking_qs_str{

     NSString *qs_rank = self.ranking_qs.integerValue == DEFAULT_NUMBER ? @"暂无排名" : [NSString stringWithFormat:@"%@",self.ranking_qs];
    
    return  qs_rank;
}


- (NSString *)introduction{

    NSString *tmp_intr = @"";
    
    return  _introduction ? _introduction : tmp_intr;
}



@end
