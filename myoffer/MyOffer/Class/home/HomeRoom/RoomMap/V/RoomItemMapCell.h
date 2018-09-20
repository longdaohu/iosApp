//
//  RoomItemMapCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/19.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomItemFrameModel.h"
#import "HomeRoomIndexFlatsObject.h"

@interface RoomItemMapCell : UICollectionViewCell
@property(nonatomic,strong)RoomItemFrameModel *itemFrameModel;
@property(nonatomic,strong)HomeRoomIndexFlatsObject *item;

@end
