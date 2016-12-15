//
//  CatigoryRank.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigoryRank.h"

@implementation CatigoryRank


-(instancetype)initWithIconName:(NSString *)iconName titleName:(NSString *)title rankType:(NSString *)type
{
    
    self = [super init];
    
    if (self) {
        
        self.iconName = iconName;
        self.titleName = title;
        self.rankType = type;
        
         if ([title containsString:@"Australia"]) {
            
            self.countryName = GDLocalizedString(@"CategoryVC-AU");
             
        }else if([title containsString:@"TIMES"]){
            
            self.countryName = GDLocalizedString(@"CategoryVC-UK");
            
        }else{
            
            self.countryName = nil;
        }
     }
    return self;
}

+(instancetype)rankItemInitWithIconName:(NSString *)iconName titleName:(NSString *)title rankType:(NSString *)type{
    
    return [[self alloc] initWithIconName:iconName titleName:title rankType:type];
}


@end
