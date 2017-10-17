//
//  XWGJCatigorySubject.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigorySubject.h"

@implementation CatigorySubject


-(instancetype)initWithIcon:(NSString *)icon title:(NSString *)title
{
    
    self = [super init];
    if (self) {
        
        self.icon = icon;
        
        self.title = title;
    }
    
    return self;
}

+ (instancetype)subjectItemInitWithIcon:(NSString *)icon title:(NSString *)title
{
    return [[self alloc] initWithIcon:icon title:title];
}

@end
