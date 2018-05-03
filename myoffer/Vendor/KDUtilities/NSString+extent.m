//
//  NSString+extent.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "NSString+extent.h"

@implementation NSString (extent)

- (NSString *)JH_stringUTF8WithString{
  
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
