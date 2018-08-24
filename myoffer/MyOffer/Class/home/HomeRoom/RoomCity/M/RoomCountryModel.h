//
//  RoomCountryModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomCountryModel : NSObject
@property(nonatomic,strong)NSArray *au;
@property(nonatomic,strong)NSArray *uk;
@property(nonatomic,copy)NSString *current;
@property(nonatomic,strong)NSArray *group;
@property(nonatomic,strong,readonly)NSArray *titles;

@end
