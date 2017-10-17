//
//  MyOfferCountryState.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOfferCountryState : NSObject
@property(nonatomic,copy)NSString *state_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSArray *cities;

@end
