//
//  YYSingleNewsBO.m
//  YYDailyNewsDemo
//
//  Created by REiFON-MAC on 15/12/28.
//  Copyright © 2015年 L. All rights reserved.
//

#import "YYSingleNewsBO.h"

@implementation YYSingleNewsBO

-(void)setMessage:(NSDictionary *)message
{
    _message = message;
    
    self.newsTitle = message[@"title"];
    self.imageUrl = [message[@"cover_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.newsId = message[@"_id"];
    self.message_url = [message[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setBanner:(NSDictionary *)banner{

    _banner = banner;
    
    self.newsTitle = banner[@"title"];
    self.imageUrl = [banner[@"thumbnail"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.newsId = banner[@"_id"];
    self.message_url = [banner[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
}

@end
