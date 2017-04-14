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
             @"related_universities" : @"UniversityNew"
             };
}

@end
