//
//  RootTagsCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomItemFrameModel.h"

@interface RootTagsCell : UITableViewCell
@property(nonatomic,strong)RoomItemFrameModel *itemFrameModel;
@property(nonatomic,strong)NSArray *items;

@end
