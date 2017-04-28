//
//  MyOfferRank.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOfferRank : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *rankType;

+ (instancetype)rankWithName:(NSString *)name;
@end
