//
//  RoomTypeBookItemModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomTypeBookItemModel : NSObject
//@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *accommodation_id;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *weeks;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,copy)NSString *roomtype_id;
@property(nonatomic,copy)NSString *start_date;
@property(nonatomic,copy)NSString *end_date;
@property(nonatomic,copy)NSString *source_id;

@property(nonatomic,copy)NSString *currency;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *priceCurrency;
@property(nonatomic,copy)NSString *currentState;


@end
