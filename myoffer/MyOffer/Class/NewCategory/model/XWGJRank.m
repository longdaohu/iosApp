//
//  XWGJRank.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJRank.h"

@implementation XWGJRank


-(instancetype)initWithIconName:(NSString *)iconName TitleName:(NSString *)Name RankKey:(NSString *)key
{
    if ([super init]) {
        self.IconName = iconName;
        self.TitleName = Name;
        self.key = key;
        
         if ([Name containsString:@"Australia"]) {
            
            self.countryName = GDLocalizedString(@"CategoryVC-AU");
             
        }else if([Name containsString:@"TIMES"]){
            
            self.countryName = GDLocalizedString(@"CategoryVC-UK");
            
        }else{
            
            self.countryName = nil;
        }
     }
    return self;
}

+(instancetype)rankItemInitWithIconName:(NSString *)iconName TitleName:(NSString *)Name RankKey:(NSString *)key
{
    return [[self alloc] initWithIconName:iconName TitleName:Name RankKey:key];
}


@end
