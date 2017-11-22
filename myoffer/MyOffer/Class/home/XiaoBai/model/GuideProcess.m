//
//  GuideProcess.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/11/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "GuideProcess.h"
#import "GuideItem.h"

@implementation GuideProcess

+ (NSDictionary *)mj_replacedKeyFromPropertyName{

    return @{@"desc":@"description"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"items" : @"GuideItem"};
}




@end
