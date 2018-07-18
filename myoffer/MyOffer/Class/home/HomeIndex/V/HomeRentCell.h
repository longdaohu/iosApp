//
//  HomeRentCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRentCell : UITableViewCell
@property(nonatomic,copy)void(^actionBlock)(NSString *path);
@end
