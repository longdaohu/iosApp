//
//  MessgeTopicModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessgeTopicModel.h"

@implementation MessgeTopicModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"article_id" : @"_id"};
    
}


+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"articles" : @"MyOfferArticle"};
}

@end
