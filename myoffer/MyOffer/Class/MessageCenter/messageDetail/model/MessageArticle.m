//
//  MessageArticle.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageArticle.h"

@implementation MessageArticle

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"article_id" : @"_id"};
    
}


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"recommendations" : @"MyOfferArticle",
             @"related_universities" : @"MyOfferUniversityModel"
             };
}

- (NSString *)cover_url{
    
    NSString *path = [_cover_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
 
    return path;
}


- (NSString *)right_str{
    
    if (!_right_str) {
        
        NSArray *times = [self.update_at componentsSeparatedByString:@"/"];
        if(times.count >= 3){
            _right_str = [NSString stringWithFormat:@"阅读量 %@  |  %@年%@月%@日",self.view_count,times.lastObject,times.firstObject,times[1]];
        }
    }
    
    return _right_str;
    
}

@end
