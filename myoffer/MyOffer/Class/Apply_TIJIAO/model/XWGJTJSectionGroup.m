//
//  XWGJTJSectionGroup.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJTJSectionGroup.h"
@implementation XWGJTJSectionGroup

+ (instancetype)groupInitWithTitle:(NSString *)title celles:(NSArray *)celles{
   
    return [[self alloc] initWithTitle:title celles:celles];
}

-(instancetype)initWithTitle:(NSString *)title  celles:(NSArray *)celles{

    self = [super init];
    
    if (self) {
        
        self.sectionTitleName = title;
        self.celles = [celles copy];
        
    }
    
    return self;
}






@end
