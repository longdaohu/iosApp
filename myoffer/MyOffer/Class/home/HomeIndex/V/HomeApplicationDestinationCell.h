//
//  HomeApplicationDestinationCell.h
//  newOffer
//
//  Created by xuewuguojie on 2018/6/11.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeApplicationDestinationCell : UITableViewCell
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)void(^actionBlock)(NSDictionary *);
@end
