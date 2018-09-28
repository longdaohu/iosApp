//
//  HomeRoomIndexModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeRoomIndexFrameObject.h"


@interface HomeRoomIndexModel : NSObject
@property(nonatomic,strong)HomeRoomIndexFrameObject *UKRoomFrameObj;
@property(nonatomic,strong)HomeRoomIndexFrameObject *AURoomFrameObj;
@property(nonatomic,strong,readonly)HomeRoomIndexFrameObject *current_roomFrameObj;
@property(nonatomic,assign)BOOL isUK;
@property(nonatomic,copy,readonly)NSString *country;
@property(nonatomic,assign,readonly)NSInteger country_code;
@property(nonatomic,strong)NSArray *groups;

- (void)updateGroupData;

@end
