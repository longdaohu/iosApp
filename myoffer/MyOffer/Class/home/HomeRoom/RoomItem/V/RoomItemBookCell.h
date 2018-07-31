//
//  RoomItemBookCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomItemBookCell : UITableViewCell
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)void(^actionBlock)();

@end
