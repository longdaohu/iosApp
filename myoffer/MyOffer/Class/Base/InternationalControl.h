//
//  InternationalControl.h
//  国际化一
//
//  Created by sara on 15/10/3.
//  Copyright © 2015年 小米. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternationalControl : NSObject
+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言

@end
