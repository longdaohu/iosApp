//
//  XWGJTJSectionGroup.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJTJSectionGroup.h"
#import "XWGJPeronInfoItem.h"
@implementation XWGJTJSectionGroup

+(instancetype)groupInitWithTitle:(NSString *)titleName andSecitonIcon:(NSString *)iconName andContensArray:(NSArray *)items
{
    return [[self alloc] initWithTitle:titleName andSecitonIcon:iconName andContensArray:items];
}

-(instancetype)initWithTitle:(NSString *)titleName andSecitonIcon:(NSString *)iconName andContensArray:(NSArray *)items
{
   
    if ([super init]) {
        
        self.SectionIconName = iconName;
        self.SectionTitleName = titleName;
        self.cellItems = items;

    }
    return self;
}




@end
