//
//  PeiperGroup.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/3/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "PeiperGroup.h"

@implementation PeiperGroup

+ (instancetype)groupWithTitle:(NSString *)title subtitle:(NSString *)subtitle items:(NSArray *)items{

    PeiperGroup *group = [PeiperGroup new];
    group.title = title;
    group.subtitle = subtitle;
    group.items = items;
    
    return group;
}

@end
