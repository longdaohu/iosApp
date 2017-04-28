//
//  MyOfferRank.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferRank.h"

@implementation MyOfferRank

+ (instancetype)rankWithName:(NSString *)name{

    MyOfferRank *rank = [[MyOfferRank alloc] init];
    
    rank.name = name;
    
    return rank;
}


- (void)setName:(NSString *)name{

    _name = name;
    
    self.rankType = [name containsString:@"世界"] ?  RANK_QS : RANK_TI;
    
}

@end
