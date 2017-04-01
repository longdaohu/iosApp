//
//  EmallCatigoryGroup.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "EmallCatigoryGroup.h"

@implementation EmallCatigoryGroup

+ (instancetype)groupWithCatigory:(NSString *)catigroy items:(NSArray *)skus{

    EmallCatigoryGroup *group = [EmallCatigoryGroup new];
    
    group.catigroy = catigroy;
    
    group.sku_frames = skus;
    
    
    
    return group;
}
@end
