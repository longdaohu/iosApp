//
//  XUCountry.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/22.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "XUCountry.h"
#import "CountryState.h"

@implementation XUCountry
+(instancetype)CreateCountry:(NSString *)countryName andStates:(NSArray *)states
{
    return [[self alloc] initWithCountry:countryName andStates:states];
}

-(instancetype)initWithCountry:(NSString *)countryName andStates:(NSArray *)states
{
     self =[super init];
    if (self) {
        self.countryName = countryName;
        self.states = states;
    }
    return self;
}



+(instancetype)countryInitWithCountryDictionary:(NSDictionary *)dic
{
    return  [[self alloc] initWithCountryWithCountryDictionary:dic];
}


-(instancetype)initWithCountryWithCountryDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        
        self.countryName = dic[@"name"];
        
        NSMutableArray *temps =[NSMutableArray array];
        
        for (NSDictionary *StateDic in dic[@"states"]) {
            
            CountryState *state =[CountryState stateInitWithStateWithStateDictionary:StateDic];
            [temps addObject:state];
            
        }
        self.states = [temps copy];
    }
    
    return self;
}

@end
