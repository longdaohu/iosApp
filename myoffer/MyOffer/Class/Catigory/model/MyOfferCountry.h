//
//  MyOfferCountry.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOfferCountry : NSObject
@property(nonatomic,copy)NSString *country_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSArray *states;

@end
