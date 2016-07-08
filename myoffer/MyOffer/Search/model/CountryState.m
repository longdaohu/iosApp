//
//  ContryState.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/17.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CountryState.h"

@implementation CountryState

+(instancetype)stateInitWithStateWithStateDictionary:(NSDictionary *)dic
{
    return  [[self alloc] initWithStateWithStateDictionary:dic];
}

-(instancetype)initWithStateWithStateDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.stateName = dic[@"name"];
        
        NSMutableArray *temps =[NSMutableArray array];
        
        for (NSDictionary *cityDic in dic[@"cities"]) {
           
            [temps addObject:cityDic[@"name"]];
        }
         self.cities = [temps copy];
        
      }
    return self;
}

@end
