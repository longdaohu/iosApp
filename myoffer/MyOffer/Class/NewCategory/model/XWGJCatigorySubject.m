//
//  XWGJCatigorySubject.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJCatigorySubject.h"

@implementation XWGJCatigorySubject


-(instancetype)initWithIconName:(NSString *)iconName TitleName:(NSString *)Name
{
    if ([super init]) {
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
