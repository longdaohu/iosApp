//
//  MessageCategoryItem.m
//  myOffer
//
//  Created by sara on 16/1/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessageCategoryItem.h"

@implementation XWGJMessageCategoryItem

- (instancetype)initWithName:(NSString *)name lastPage:(NSInteger)lastPage
{
    if (self = [super init]) {
        
        self.name = name;
        self.LastPage = lastPage;
    }
    return self;
}

+ (instancetype)categoryInitWithName:(NSString *)name lastPage:(NSInteger)lastPage{
    
    return [[self alloc] initWithName:name lastPage:lastPage];
}


@end
