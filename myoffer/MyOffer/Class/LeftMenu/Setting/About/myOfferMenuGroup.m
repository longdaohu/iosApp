//
//  myOfferMenuGroup.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "myOfferMenuGroup.h"

@implementation myOfferMenuGroup

+ (instancetype)itemWithTitle:(NSString *)title items:(NSArray *)items moreTitle:(NSString *)moreTitle headerHeigh:(CGFloat)headerHeigh footerHeigh:(CGFloat)footerHeigh arrow:(BOOL)arrow active:(NSString *)active{
    
    return [[myOfferMenuGroup alloc] initItemWithTitle:title items:items moreTitle:moreTitle headerHeigh:headerHeigh footerHeigh:footerHeigh arrow:arrow active:active];
}

- (instancetype)initItemWithTitle:(NSString *)title items:(NSArray *)items moreTitle:(NSString *)moreTitle headerHeigh:(CGFloat)headerHeigh footerHeigh:(CGFloat)footerHeigh arrow:(BOOL)arrow active:(NSString *)active{
    
    self = [super init];
    
    if (self) {
        
        self.items = items;
        self.title = title;
        self.more_title = moreTitle;
        self.arrow = arrow ? true : false;
        if (items.count>0) {
        
            self.header_heigh = headerHeigh ? headerHeigh : Section_header_Height_nomal;
            self.footer_heigh = footerHeigh ? footerHeigh : Section_footer_Height_nomal;
            self.active = active;
        }
    
    }
    
    return self;
}

@end
