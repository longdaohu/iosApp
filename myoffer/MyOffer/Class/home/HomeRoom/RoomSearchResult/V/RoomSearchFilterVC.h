//
//  RoomSearchFilterVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomSearchFilterVC : UIViewController
@property(nonatomic,copy)void(^actionBlock)();
- (void)show;
@end
