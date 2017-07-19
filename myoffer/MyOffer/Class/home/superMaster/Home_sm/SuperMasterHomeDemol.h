//
//  SuperMasterHomeDemol.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTagModel.h"

@interface SuperMasterHomeDemol : NSObject

@property(nonatomic,strong)NSArray *hots;
@property(nonatomic,strong)NSArray *banners;
@property(nonatomic,strong)NSArray *newest;
@property(nonatomic,strong)SMTagModel *tag;
@property(nonatomic,strong)NSDictionary *offline;

@end
