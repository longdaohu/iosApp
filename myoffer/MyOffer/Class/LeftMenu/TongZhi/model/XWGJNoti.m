//
//  XWGJNoti.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJNoti.h"

@implementation XWGJNoti

+(instancetype)notiCreateWithDic:(NSDictionary *)notiInfomation
{
    return [[self alloc] initWithDic:notiInfomation];
}
-(instancetype)initWithDic:(NSDictionary *)notiInfomation
{
    self = [super init];
    if (self) {
        
        self.NO_id = notiInfomation[@"_id"];
        self.content = notiInfomation[@"content"];
        self.summary = notiInfomation[@"summary"];
        self.state = notiInfomation[@"state"];
        self.create_at = notiInfomation[@"create_at"];
        self.category_id = notiInfomation[@"category_id"];
        self.category = notiInfomation[@"category"];
    }
    return self;
}

@end
/*
 @property(nonatomic,copy)NSString *NO_id;
 @property(nonatomic,copy)NSString *content;
 @property(nonatomic,copy)NSString *summary;
 @property(nonatomic,copy)NSString *state;
 @property(nonatomic,copy)NSString *create_at;
 @property(nonatomic,copy)NSString *;
 */