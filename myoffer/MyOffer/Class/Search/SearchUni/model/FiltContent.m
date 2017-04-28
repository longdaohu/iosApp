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
        
        self.icon = icon;
        self.title = title;
        self.subtitle = subtitle;
        self.optionItems = optionItems;
        
    }
    return self;
}



- (id)copyWithZone:(nullable NSZone *)zone{
    
    
    FiltContent *copy = [[FiltContent allocWithZone:zone] init];
    
    copy.title = [self.title copy];
    copy.subtitle = [self.subtitle copy];
    copy.optionItems = [self.optionItems copy];
    copy.selectedValue = [self.selectedValue copy];
    copy.icon = [self.icon copy];
    copy.optionStyle = self.optionStyle;
    
    return copy;
    
}


 




@end
