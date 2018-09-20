//
//  HomeRoomSearchVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomSearchResultItemModel.h"

@interface HomeRoomSearchVC : BaseViewController
@property(nonatomic,copy)void(^actionBlock)(RoomSearchResultItemModel *item);

@end
