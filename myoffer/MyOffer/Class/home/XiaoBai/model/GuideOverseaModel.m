//
//  GuideOverseaModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/11/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "GuideOverseaModel.h"
#import "GuideProcess.h"

@implementation GuideOverseaModel

+ (NSDictionary *)mj_objectClassInArray{

    return @{@"process" : @"GuideProcess"};
}

- (NSArray *)process_arr{
    
    NSArray *pro_arr =  [self.process copy];
    GuideProcess *pro  = pro_arr.lastObject;
    pro.line_hiden = true;
 
    return pro_arr;
    
}



@end
