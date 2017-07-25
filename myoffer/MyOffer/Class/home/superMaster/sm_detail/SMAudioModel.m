//
//  SMAudioModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMAudioModel.h"
#import "SMAudioItem.h"

@implementation SMAudioModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"fragments" :  NSStringFromClass([SMAudioItem class])
             };
}


@end
