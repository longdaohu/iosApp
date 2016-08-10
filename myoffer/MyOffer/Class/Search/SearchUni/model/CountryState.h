//
//  ContryState.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/17.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryState : NSObject
@property(nonatomic,copy)NSString *stateName;
@property(nonatomic,strong)NSArray *cities;

-(instancetype)initWithStateWithStateDictionary:(NSDictionary *)dic;
+(instancetype)stateInitWithStateWithStateDictionary:(NSDictionary *)dic;

@end
