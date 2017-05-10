//
//  CatigaryHotCity.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatigaryHotCity : NSObject
//城市id
@property(nonatomic,copy)NSString *city_id;
//城市名称
@property(nonatomic,copy)NSString *city;

@property(nonatomic,copy)NSString *country;
//城市图片
@property(nonatomic,copy)NSString *image_url;
//自定义图片名称
@property(nonatomic,copy)NSString *imageName;

@end
