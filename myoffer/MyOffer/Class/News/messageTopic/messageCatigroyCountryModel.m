//
//  messageCatigroyCountryModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "messageCatigroyCountryModel.h"
#import "messageCatigroyModel.h"

@implementation messageCatigroyCountryModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"subs" :   NSStringFromClass([messageCatigroyModel class])};
}


@end
