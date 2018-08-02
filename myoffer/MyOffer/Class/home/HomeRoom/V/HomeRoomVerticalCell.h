//
//  HomeRoomVerticalCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/2.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myofferGroupModel.h"
#import "HomeRoomIndexFrameObject.h"

@interface HomeRoomVerticalCell : UITableViewCell
@property(nonatomic,strong)HomeRoomIndexFrameObject *roomFrameObj;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)void(^actionBlock)(NSInteger index,id item);
- (void)bottomLineHiden:(BOOL)hiden;

@end
