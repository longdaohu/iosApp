//
//  UniversityNew.m
//  myOffer
//
//  Created by xuewuguojie on 2016/10/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityNew.h"
#import "SearchUniCourseFrame.h"

@implementation UniversityNew
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NO_id" : @"_id",@"found_year" : @"found"};
    
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"courses" : @"UniversityCourse"};
}

//- (NSArray *)courseFrames{
//    
//    NSMutableArray *temps = [NSMutableArray array];
//    
//    [self.courses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        SearchUniCourseFrame *courseFrame = [SearchUniCourseFrame frameWithCourse: (UniversityCourse *)obj];
//        
//        [temps addObject:courseFrame];
//    }];
//    
//    
//    return [temps copy];
//    
//}


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



@end
