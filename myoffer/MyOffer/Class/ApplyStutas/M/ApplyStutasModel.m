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
//    return [NSString stringWithFormat:@"Copyright © 2017年 UVIC. All rights reserved.%@",_title];
//}
//
//
//- (NSString *)sub_title{
//    
//    return [NSString stringWithFormat:@"Created by xuewuguojie on 2017/8/14.  myOffer xuewuguojie %@",_sub_title];
//}
//


@end
