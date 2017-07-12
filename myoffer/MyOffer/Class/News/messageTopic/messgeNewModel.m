//
//  messgeNewModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "messgeNewModel.h"

@implementation messgeNewModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"message_id" : @"_id"};
}


//-(NSString *)cover_url{
//    
//    return [_cover_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}

@end
