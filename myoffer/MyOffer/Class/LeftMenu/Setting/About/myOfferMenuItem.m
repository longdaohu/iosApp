//
//  myOfferMenuItem.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "myOfferMenuItem.h"

@implementation myOfferMenuItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title arrow:(BOOL)arrow accessoryTitle:(NSString *)accessoryTitle accessoryImage:(NSString *)accessoryImage  active:(NSString *)active{
    
    return [[myOfferMenuItem alloc] initItemWithIcon:icon title:title arrow:arrow accessoryTitle:accessoryTitle accessoryImage:accessoryImage active:active];
}

- (instancetype)initItemWithIcon:(NSString *)icon title:(NSString *)title arrow:(BOOL)arrow accessoryTitle:(NSString *)accessoryTitle accessoryImage:(NSString *)accessoryImage  active:(NSString *)active{
    
    self = [super init];
    
    if (self) {
        
        self.icon = icon;
        self.title = title;
        self.accessoryArrow = arrow;
        self.accessory_title = accessoryTitle;
        self.accessory_image = accessoryImage;
        self.active = active;
        self.cell_height = 44;
    }
    
    return self;
}





@end
