//
//  RoomSearchFilterView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RoomFilterType){
    RoomFilterTypeCity = 0,
    RoomFilterTypePrice,
    RoomFilterTypefilte
};

@interface RoomSearchFilterView : UIView
@property(nonatomic,copy)void(^RoomSearchFilterViewBlock)(RoomFilterType);

@end
