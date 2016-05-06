//
//  XWGJRank.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJRank : NSObject
//图片
@property(nonatomic,copy)NSString *IconName;
//标题
@property(nonatomic,copy)NSString *TitleName;
//国家名称
@property(nonatomic,copy)NSString *countryName;
//排名方式
@property(nonatomic,copy)NSString *key;

+(instancetype)rankItemInitWithIconName:(NSString *)iconName TitleName:(NSString *)Name RankKey:(NSString *)key;
-(instancetype)initWithIconName:(NSString *)iconName TitleName:(NSString *)Name RankKey:(NSString *)key;

@end
