//
//  NewsItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"message_id" : @"_id"};
    
}


-(NSString *)cover_url{

    return [_cover_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)cover_url_thumbnail{
    
    return [_cover_url_thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
