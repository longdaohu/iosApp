//
//  RoomItemHeaderView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomItemFrameModel.h"

@interface RoomItemHeaderView : UIView
@property(nonatomic,strong)RoomItemFrameModel  *itemFrameModel;
@property(nonatomic,copy)void(^actionBlock)(void);
@end
