//
//  RoomItemDetailVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomBaseVC.h"

@interface RoomItemDetailVC : RoomBaseVC
@property(nonatomic,copy)NSString *room_id;
@property(nonatomic,assign)BOOL isFromMap;

@end
