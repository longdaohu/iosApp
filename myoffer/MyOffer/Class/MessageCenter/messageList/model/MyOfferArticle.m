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

//    NSLog(@" %@ title =  %@",_cover_url,self.title);
    return [_cover_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)cover_url_thumbnail{
    
    return [_cover_url_thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)view_count{

    return [NSString stringWithFormat:@"%@阅读",_view_count];
}

@end
