//
//  messageCatigroyModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "messageCatigroyModel.h"
#import "messageCatigroySubModel.h"

@implementation messageCatigroyModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"subs" :   NSStringFromClass([messageCatigroySubModel class])};
}

@end
