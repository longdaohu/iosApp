//
//  ApplyStutasModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStutasModel.h"

@implementation ApplyStutasModel
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"history" :  NSStringFromClass([ApplyStutasHistoryModel class]),
             };
}


//- (NSString *)title{
//
//    
//    NSString *path = @"这是为什么呢一生有你地";
//    
//    
//    return [NSString stringWithFormat:@"%@%@",_title,path];
//}

@end
