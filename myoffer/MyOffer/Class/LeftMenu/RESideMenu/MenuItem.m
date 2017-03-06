//
//  MenuItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

-(instancetype)initWithName:(NSString *)name icon:(NSString *)icon count:(NSString *)messageCount classString:(NSString *)classStr{

    self =[super init];
    if (self) {
        
        self.classString = classStr;
        self.name = name;
        self.icon = icon;
        self.messageCount = messageCount;
    }
    return self;

}

+(instancetype)menuItemInitWithName:(NSString *)name icon:(NSString *)icon classString:(NSString *)classStr{

 
    return [[self alloc] initWithName:name icon:icon count:@"0" classString:classStr];

}

+(instancetype)menuItemInitWithName:(NSString *)name icon:(NSString *)icon count:(NSString *)messageCount {

    return [[self alloc] initWithName:name icon:icon count:messageCount classString:nil];

}


@end
