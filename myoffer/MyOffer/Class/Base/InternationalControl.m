//
//  InternationalControl.m
//  国际化一
//
//  Created by sara on 15/10/3.
//  Copyright © 2015年 小米. All rights reserved.
//

#import "InternationalControl.h"

@implementation InternationalControl

static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    
    
    //  NSLog(@"bundle.bundlePath   ==  language = %@",bundle.bundlePath);
    
    return bundle;
    
}
+(void)initUserLanguage{
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *useLanguage = [def valueForKey:@"userLanguage"];
    
    
    if(useLanguage.length == 0){
        
        //获取系统当前语言版本(中文zh-Hans,英文en    zh-cn)
        
        //        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        
        NSString *current =  @"zh-cn";//[languages objectAtIndex:0];
        
        useLanguage = current ;//
        
        [def setValue:current forKey:@"userLanguage"];
        
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans.lproj" ofType:nil];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
    
    /*
     if ( [useLanguage containsString:@"en"]) {
     
     NSString *path = [[NSBundle mainBundle] pathForResource:@"en.lproj" ofType:nil];
     NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans.lproj" ofType:nil];
     
     bundle = [NSBundle bundleWithPath:path];//生成bundle
     } else{
     
     
     }
     */
    
}

+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:@"zh-cn" forKey:@"userLanguage"];
    //    [def setValue:language forKey:@"userLanguage"];
    
    [def synchronize];
}


+(NSString *)userLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *language = [def valueForKey:@"userLanguage"];
    
    return language;
}


@end

