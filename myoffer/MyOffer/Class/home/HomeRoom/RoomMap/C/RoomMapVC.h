//
//  RoomMapVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomBaseVC.h"
#import "RoomItemFrameModel.h"

@interface RoomMapVC : RoomBaseVC
@property(nonatomic,strong)RoomItemFrameModel *itemFrameModel;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,assign)BOOL isUK;

@end

