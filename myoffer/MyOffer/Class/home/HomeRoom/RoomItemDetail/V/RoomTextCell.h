//
//  RoomTextCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomItemFrameModel.h"

@interface RoomTextCell : UITableViewCell
@property(nonatomic,copy)NSString *item;
@property(nonatomic,strong)RoomItemFrameModel *itemFrameModel;

@end
