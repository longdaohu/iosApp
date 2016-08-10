//
//  XWGJNoti.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJNoti : NSObject
@property(nonatomic,copy)NSString *NO_id;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *summary;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *create_at;
@property(nonatomic,copy)NSString *category_id;
@property(nonatomic,copy)NSString *category;

+(instancetype)notiCreateWithDic:(NSDictionary *)notiInfomation;
-(instancetype)initWithDic:(NSDictionary *)notiInfomation;

@end
