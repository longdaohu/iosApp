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
    return @{@"messageID" : @"_id",
             @"LogoName" : @"cover_url",
             @"cover_url_thumbnail" : @"cover_url_thumbnail",
             @"messageTitle" : @"title",
             @"FocusCount" : @"view_count",
             @"Update_time" : @"update_at"
             };
    
}

-(NSString *)LogoName{

    return [_LogoName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
