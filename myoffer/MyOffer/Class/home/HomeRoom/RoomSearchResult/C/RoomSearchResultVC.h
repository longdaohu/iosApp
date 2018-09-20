//
//  RoomSearchResultVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomBaseVC.h"
#import "RoomSearchResultItemModel.h"
#import "HomeRoomIndexCityObject.h"

@interface RoomSearchResultVC : RoomBaseVC
@property(nonatomic,strong)RoomSearchResultItemModel *item;
@property(nonatomic,strong)HomeRoomIndexCityObject *city;
//@property(nonatomic,strong)NSDictionary *parameterItem;

@end
