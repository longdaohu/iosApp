//
//  HomeSingleImageCell.h
//  newOffer
//
//  Created by xuewuguojie on 2018/6/13.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRoomIndexCityObject.h"

@interface HomeSingleImageCell : UICollectionViewCell
@property(nonatomic,copy)NSString *path;
@property(nonatomic,strong)NSDictionary *item;
@property(nonatomic,strong)HomeRoomIndexCityObject *city;
@property(nonatomic,assign)BOOL shadowEnable;
@property(nonatomic,strong)UIImageView *iconView;


@end
