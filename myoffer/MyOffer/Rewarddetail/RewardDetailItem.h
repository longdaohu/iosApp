//
//  RewardDetailItem.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardDetailItem : NSObject
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *bankReceiptName;
@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,copy)NSString *bankAccount;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *stateDisplay;
@property(nonatomic,strong)NSArray *stateHistory;
@property(nonatomic,strong)NSArray *statusGroup;
@property(nonatomic,strong)NSArray *userGroup;



@property(nonatomic,copy)NSString *displayname;
@property(nonatomic,copy)NSString *phonenumber;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,strong)NSArray *otherGroup;

@end



