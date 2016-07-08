//
//  MenuItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

+(instancetype)menuItemInitWithName:(NSString *)name icon:(NSString *)icon
{
    
    return [[self alloc] initWithName:name icon:icon];
}

-(instancetype)initWithName:(NSString *)name icon:(NSString *)icon
{
    self =[super init];
    if (self) {
        self.name = name;
        self.icon = icon;
        self.newMessage = NO;
    }
    return self;
}


@end
