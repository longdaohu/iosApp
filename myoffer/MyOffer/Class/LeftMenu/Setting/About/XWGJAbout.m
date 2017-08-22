//
//  XWGJAbout.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJAbout.h"

@implementation XWGJAbout

+ (instancetype)cellWithLogo:(NSString *)logo title:(NSString *)title sub_title:(NSString *)subName accessory_title:(NSString *)acc_title accessory_icon:(NSString *)acc_icon{

    return  [[self alloc] initWithLogo:logo title:title sub_title:subName accessory_title:acc_title accessory_icon:acc_icon];
}


- (instancetype)initWithLogo:(NSString *)logo title:(NSString *)title sub_title:(NSString *)subName accessory_title:(NSString *)acc_title accessory_icon:(NSString *)acc_icon{
    
    self = [super init];
    
    if (self) {
        
        self.Logo = logo;
        self.title = title;
        self.sub_title =subName;
        self.acc_title = acc_title;
        self.acc_icon = acc_icon;
        self.accessoryType = NO;
        self.cell_height = 44.0f;
    }
    
    return self;
}

@end
