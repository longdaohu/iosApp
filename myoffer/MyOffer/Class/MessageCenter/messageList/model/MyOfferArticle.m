//
//  MyOfferArticle.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "MyOfferArticle.h"

@implementation MyOfferArticle

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"message_id" : @"_id",@"desc":@"description"};
    
}


-(NSString *)cover_url{

    return [_cover_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)cover_url_thumbnail{
    
    return [_cover_url_thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end