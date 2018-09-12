//
//  ServiceItem.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceItem : NSObject
@property(nonatomic,assign)BOOL login_status;
@property(nonatomic,copy)NSString *service_id;
@property(nonatomic,copy)NSString *product_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,strong)NSString *price_str;
@property(nonatomic,strong)NSNumber *display_price;
@property(nonatomic,strong)NSString *display_price_str;
@property(nonatomic,assign)BOOL isZheKou;
@property(nonatomic,assign)BOOL online;
@property(nonatomic,strong)NSNumber *rank;
@property(nonatomic,copy)NSString *detail;
@property(nonatomic,copy)NSString *create_at;
@property(nonatomic,copy)NSString *update_at;
@property(nonatomic,copy)NSString *online_at;
@property(nonatomic,copy)NSString *product_name;
@property(nonatomic,copy)NSString *summary;
@property(nonatomic,copy)NSString *product_category;
@property(nonatomic,copy)NSArray *agreements;
@property(nonatomic,copy)NSArray *attributes;
@property(nonatomic,copy)NSString *cover_url;
@property(nonatomic,strong)NSNumber *product_rank;
@property(nonatomic,assign)BOOL headline;
@property(nonatomic,assign)BOOL headline_app;
@property(nonatomic,copy)NSString *short_id;
@property(nonatomic,strong)NSNumber *total_fee;
@property(nonatomic,copy)NSDictionary *comment_type;
@property(nonatomic,copy)NSDictionary *comment_present;
@property(nonatomic,copy)NSString *presentDisc;
@property(nonatomic,copy)NSDictionary *comment_suit_people;
@property(nonatomic,copy)NSString *peopleDisc;
@property(nonatomic,copy)NSDictionary *comment_country;
@property(nonatomic,strong)NSDictionary *country_Attibute;
@property(nonatomic,strong)NSDictionary *serviceType_Attibute;
@property(nonatomic,assign)BOOL reduce_flag;
@property(nonatomic,strong)NSArray *comment_attr;

//添加属性
@property(nonatomic,assign)BOOL fitPerson_hiden;

@end
