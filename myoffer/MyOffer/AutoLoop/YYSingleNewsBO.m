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

@end
