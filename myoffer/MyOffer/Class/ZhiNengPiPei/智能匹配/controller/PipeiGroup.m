//
//  PipeiGroup.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiGroup.h"

@implementation PipeiGroup
+ (instancetype)groupWithHeader:(NSString *)header groupType:(PipeiGroupType)type{

    PipeiGroup *group = [[PipeiGroup alloc] init];
    group.header = header;
    group.groupType = type;
    return group;
}

 

@end
