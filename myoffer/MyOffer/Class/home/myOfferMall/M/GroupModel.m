//
//  GroupModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/11.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

+ (instancetype)groupWithIndex:(NSInteger)index header:(NSString *)header footer:(NSString *)footer items:(NSArray *)items{

    GroupModel *group = [[GroupModel alloc] init];
    
    group.index = index;
    group.header = header;
    group.footer = footer;
    group.items  = items;
    
    return group;
}


@end
