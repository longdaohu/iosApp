//
//  EmallCatigoryGroup.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmallCatigoryGroup : NSObject
@property(nonatomic,copy)NSString *catigroy;
@property(nonatomic,strong)NSArray *sku_frames;

+ (instancetype)groupWithCatigory:(NSString *)catigroy items:(NSArray *)skus;

@end
