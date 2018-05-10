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

    return [_cover_url toUTF8WithString];
}

-(NSString *)cover_url_thumbnail{
    
    return [_cover_url_thumbnail toUTF8WithString];
}

- (NSString *)view_count{

    return [NSString stringWithFormat:@"%@阅读",_view_count];
}

@end
