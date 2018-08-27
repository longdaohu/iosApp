//
//  HomeRoomTopView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HomeRoomTopViewButtonType) {
    
    HomeRoomTopViewButtonTypeUK = 0,
    HomeRoomTopViewButtonTypeAU,
    HomeRoomTopViewButtonTypeSearch,
    HomeRoomTopViewButtonTypeMap
};

@interface HomeRoomTopView : UIView
@property(nonatomic,assign)CGFloat header_height;
@property(nonatomic,copy)void(^actionBlock)(UIButton *sender);

@end
