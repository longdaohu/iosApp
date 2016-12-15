//
//  XWGJCatigorySubject.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigorySubject.h"

@implementation CatigorySubject


-(instancetype)initWithIconName:(NSString *)iconName TitleName:(NSString *)Name
{
    
    self = [super init];
    if (self) {
        
        self.IconName = iconName;
        self.TitleName = Name;
    }
    return self;
}

+(instancetype)subjectItemInitWithIconName:(NSString *)iconName TitleName:(NSString *)Name
{
    return [[self alloc] initWithIconName:iconName TitleName:Name];
}

@end
