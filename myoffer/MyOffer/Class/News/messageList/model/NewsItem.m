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
             @"messageTitle" : @"title",
             @"FocusCount" : @"view_count",
             @"Update_time" : @"update_at"
             };
    
}
@end
