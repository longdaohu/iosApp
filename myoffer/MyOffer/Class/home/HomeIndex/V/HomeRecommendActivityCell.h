//
//  HomeRecommendActivityCell.h
//  newOffer
//
//  Created by xuewuguojie on 2018/6/4.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRecommendActivityCell : UITableViewCell
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)void(^actionBlock)(NSString *active_id);

@end
