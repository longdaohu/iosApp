//
//  XWGJMessage.m
//  myOffer
//
//  Created by sara on 16/2/16.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessage.h"

@implementation XWGJMessage

+(instancetype)messageWithDictionary:(NSDictionary *)messageDic
{
    return [[self alloc] initWithDictionary:messageDic];
}

-(instancetype)initWithDictionary:(NSDictionary *)messageDic
{
    self =[super  init];
    if (self) {
        
        self.LogoName = [messageDic[@"cover_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.messageTitle = messageDic[@"title"];
        self.FocusCount = [NSString stringWithFormat:@"%@",messageDic[@"view_count"]];
        self.Update_time = messageDic[@"update_at"];
        self.messageID = messageDic[@"_id"];
      }
    
    return self;
}


@end
