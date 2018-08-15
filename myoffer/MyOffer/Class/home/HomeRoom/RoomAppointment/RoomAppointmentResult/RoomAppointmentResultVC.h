//
//  RoomAppointmentResultVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/7.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomAppointmentResultVC : UIViewController
@property(nonatomic,copy)void(^actionBlock)(BOOL isBackToHome);
@end
