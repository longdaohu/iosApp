//
//  UniversityNew.h
//  myOffer
//
//  Created by xuewuguojie on 2016/10/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UniversityNew : NSObject
@property(nonatomic,copy)NSString *NO_id;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *short_id;
@property(nonatomic,copy)NSString *postcode;
@property(nonatomic,copy)NSString *official_name;
@property(nonatomic,strong)NSNumber   *found_year; //建校年份
@property(nonatomic,assign)BOOL  private_flag;
@property(nonatomic,strong)NSNumber *ranking_qs;
@property(nonatomic,copy)NSString *ranking_qs_str;
@property(nonatomic,assign)BOOL    cn_flag;
@property(nonatomic,assign)BOOL    in_cart;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,assign)BOOL hot;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,strong)NSNumber *ranking_ti;
@property(nonatomic,copy)NSString *ranking_ti_str;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *address_long;
@property(nonatomic,strong)NSString *address_short;
@property(nonatomic,strong)NSArray *courses;
//@property(nonatomic,strong)NSArray *courseFrames;
@property(nonatomic,strong)NSArray *tags;

@end

