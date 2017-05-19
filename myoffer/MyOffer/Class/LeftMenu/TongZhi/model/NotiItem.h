//
//  NotiItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NotiItem : NSObject
@property(nonatomic,copy)NSString *NO_id;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *summary;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *create_at;
@property(nonatomic,copy)NSString *create_time_short;
@property(nonatomic,copy)NSString *category_id;
@property(nonatomic,copy)NSString *category;


@end
