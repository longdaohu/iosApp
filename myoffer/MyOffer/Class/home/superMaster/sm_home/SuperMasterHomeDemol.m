//
//  SuperMasterHomeDemol.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SuperMasterHomeDemol.h"
#import "SMHotModel.h"
#import "SMBannerModel.h"

@implementation SuperMasterHomeDemol

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"hots" :  NSStringFromClass([SMHotModel class]),
             @"newest" :  NSStringFromClass([SMHotModel class]),
             @"banners" :  NSStringFromClass([SMBannerModel class])
             };
}


@end
