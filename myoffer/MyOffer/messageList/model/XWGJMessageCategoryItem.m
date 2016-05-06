//
//  MessageCategoryItem.m
//  myOffer
//
//  Created by sara on 16/1/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessageCategoryItem.h"

@implementation XWGJMessageCategoryItem
- (instancetype)initCategoryItemWithTitle:(NSString *)titleName andLastPage:(NSInteger)page
{
    if (self = [super init]) {
        
         self.titleName = titleName;
         self.LastPage = page;
    }
    return self;
}
+ (instancetype)CreateCategoryItemWithTitle:(NSString *)titleName andLastPage:(NSInteger)page
{
    return [[self alloc] initCategoryItemWithTitle:titleName andLastPage:page];
}
@end
