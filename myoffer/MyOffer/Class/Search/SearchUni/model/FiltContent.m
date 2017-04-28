//
//  filtercontent.m
//  TESTER
//
//  Created by xuewuguojie on 15/12/15.
//  Copyright © 2015年 xuewuguojie. All rights reserved.
//

#import "FiltContent.h"
@interface FiltContent ()<NSCopying>

@end

@implementation FiltContent

+ (instancetype)filterWithIcon:(NSString *)icon  title:(NSString *)title subtitlte:(NSString *)subtitle filterOptionItems:(NSArray *)optionItems{
    
    return [[self alloc] initItemWithIcon:icon title:title subtitlte:subtitle filterOptionItems:optionItems];
}


- (instancetype)initItemWithIcon:(NSString *)icon  title:(NSString *)title subtitlte:(NSString *)subtitle filterOptionItems:(NSArray *)optionItems
{
    
    self = [super init];
    if (self) {
        
        self.logoName = icon;
        self.titleName = title;
        self.detailTitleName = subtitle;
        self.buttonArray = optionItems;
        
    }
    return self;
}



- (id)copyWithZone:(nullable NSZone *)zone{
    
    
    FiltContent *copy = [[FiltContent allocWithZone:zone] init];
    
    copy.titleName = [self.titleName copy];
    copy.detailTitleName = [self.detailTitleName copy];
    copy.buttonArray = [self.buttonArray copy];
    copy.selectedValue = [self.selectedValue copy];
    copy.logoName = [self.logoName copy];
    copy.optionStyle = self.optionStyle;
    
    return copy;
    
}


 




@end
