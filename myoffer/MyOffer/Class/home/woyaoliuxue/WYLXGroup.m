//
//  WYLXGroup.m
//  myOffer
//
//  Created by xuewuguojie on 2016/12/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "WYLXGroup.h"

@implementation WYLXGroup
+ (instancetype)groupWithHeader:(NSString *)headerTitle content:(NSString *)content cellKey:(NSString *)key{

    WYLXGroup *group = [[WYLXGroup alloc] init];
 
    group.content = content;
    group.headerTitle = headerTitle;
    group.cellKey = key;
    
    return group;
}

@end
