//
//  RoomCityVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/10.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomBaseVC.h"
@interface RoomCityVC : RoomBaseVC
@property(nonatomic,strong)void(^actionBlock)(NSString *type_id);

@end
