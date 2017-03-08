//
//  GonglueItem.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "GonglueItem.h"
#import "MyOfferArticle.h"
#import "GongLueTip.h"

@implementation GonglueItem


+ (NSDictionary *)mj_replacedKeyFromPropertyName{

    return @{@"desc":@"description"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"articles" : @"MyOfferArticle"};
}



@end
