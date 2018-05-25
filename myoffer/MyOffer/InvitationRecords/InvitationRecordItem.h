//
//  InvitationRecordItem.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitationRecordItem : NSObject
@property(nonatomic,copy)NSString *accountId;
@property(nonatomic,copy)NSString *displayname;
@property(nonatomic,copy)NSString *phonenumber;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *stateDisplay;

@end

