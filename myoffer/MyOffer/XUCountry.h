//
//  XUCountry.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/22.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XUCountry : NSObject
@property(nonatomic,copy)NSString *countryName;
@property(nonatomic,strong)NSArray *states;

-(instancetype)initWithCountry:(NSString *)countryName andStates:(NSArray *)states;
+(instancetype)CreateCountry:(NSString *)countryName andStates:(NSArray *)states;
+(instancetype)countryInitWithCountryDictionary:(NSDictionary *)dic;


@end
