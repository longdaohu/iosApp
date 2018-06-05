//
//  NSString+extent.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "NSString+extent.h"

@implementation NSString (extent)

- (NSString *)toUTF8WithString{
  
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)toDecimalStyleString{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSNumber *number = [NSNumber numberWithFloat:self.floatValue];
    NSString *numberString = [numberFormatter stringFromNumber: number];
    
    return numberString;
}





@end
