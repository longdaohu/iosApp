//
//  rankFilter.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "rankFilter.h"

@implementation rankFilter

- (NSArray *)countri_arr{
 
    NSDictionary *all = @{
                        @"name":@"全部国家",
                        @"code":@""
                        };
    NSMutableArray *temps = [NSMutableArray arrayWithArray:_countries];
    [temps insertObject:all atIndex:0];
    
    return [temps copy];
}


- (NSArray *)type_arr{
    
    NSDictionary *all = @{
                          @"name":@"全部排名",
                          @"code":@""
                          };
    NSMutableArray *temps = [NSMutableArray arrayWithArray:_types];
    [temps insertObject:all atIndex:0];
    
    return [temps copy];
}



- (NSArray *)year_arr{
    
    NSDictionary *all = @{
                          @"name":@"全部时间",
                          @"code":@""
                          };
    NSMutableArray *temps = [NSMutableArray arrayWithArray:_years];
    [temps insertObject:all atIndex:0];
    
    return [temps copy];
}

- (NSMutableDictionary *)papa_m{
    
    if (!_papa_m) {
     
        _papa_m = [NSMutableDictionary dictionary];
//        [_papa_m setValue:@5 forKey:KEY_SIZE];
//        [_papa_m setValue:@0 forKey:KEY_PAGE];


    }
    
    return _papa_m;
}






@end
