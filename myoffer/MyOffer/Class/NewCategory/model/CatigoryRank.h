//
//  CatigoryRank.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatigoryRank : NSObject
//图片
@property(nonatomic,copy)NSString *iconName;
//标题
@property(nonatomic,copy)NSString *titleName;
//国家名称
@property(nonatomic,copy)NSString *countryName;
//排名方式
@property(nonatomic,copy)NSString *rankType;

+(instancetype)rankItemInitWithIconName:(NSString *)iconName titleName:(NSString *)title rankType:(NSString *)type;

@end
