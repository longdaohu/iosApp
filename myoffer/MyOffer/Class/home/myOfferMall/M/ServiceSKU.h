//
//  ServiceSKU.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceSKU : NSObject
@property(nonatomic,copy)NSString *service_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *price_str;
@property(nonatomic,copy)NSString *display_price;
@property(nonatomic,copy)NSString *display_price_str;
@property(nonatomic,assign)BOOL    isZheKou;
@property(nonatomic,copy)NSString *cover_url;
@property(nonatomic,copy)NSString *cover_path;
@property(nonatomic,copy)NSString *total_fee;
@property(nonatomic,strong)NSDictionary *comment_type;
@property(nonatomic,strong)NSDictionary *comment_country;
@property(nonatomic,strong)NSDictionary *comment_suit_people;
@property(nonatomic,strong)NSDictionary *comment_present;

@end
