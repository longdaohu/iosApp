//
//  MediaDocModel.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/20.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKMediaDocModel.h"

@implementation TKMediaDocModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@--%@没有定义%@",@(__FILE__),@(__FUNCTION__), key);
    
}
//-(void)setValue:(id)value forKey:(NSString *)key{
//    NSLog(@"key:%@ value:%@",key,value);
//}
@end
