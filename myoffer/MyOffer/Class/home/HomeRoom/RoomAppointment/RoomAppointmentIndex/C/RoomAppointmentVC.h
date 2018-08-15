//
//  RoomAppointmentVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/9.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomAppointmentVC : UIViewController
@property(nonatomic,copy)NSString *room_id;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,copy)void(^actionBlock)(void);

@end
