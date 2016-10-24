//
//  UniversityItemNew.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniversityItemNew : NSObject
@property(nonatomic,copy)NSString *NO_id;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *short_id;
@property(nonatomic,copy)NSString *postcode;
@property(nonatomic,copy)NSString *official_name;
@property(nonatomic,strong)NSNumber   *found_year; //建校年份
@property(nonatomic,assign)BOOL  private_flag;
@property(nonatomic,strong)NSNumber *ranking_qs;
@property(nonatomic,assign)BOOL    cn_flag;
@property(nonatomic,assign)BOOL    in_cart;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,assign)BOOL hot;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,strong)NSNumber *ranking_ti;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *address_detail;

@end

