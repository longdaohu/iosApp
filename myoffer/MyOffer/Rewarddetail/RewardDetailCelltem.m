//
//  RewardDetailCelltem.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RewardDetailCelltem.h"

@implementation RewardDetailCelltem

+ (instancetype)itemWithTitle:(NSString *)title sub:(NSString *)sub{
    
    RewardDetailCelltem *item = [[RewardDetailCelltem alloc] init];
    item.title = title;
    item.sub = sub;
    
    return item;
}

@end
