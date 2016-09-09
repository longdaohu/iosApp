//
//  peronInfoItem.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/10.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "XWGJPeronInfoItem.h"

@implementation XWGJPeronInfoItem

+(instancetype)personInfoItemInitWithPlacehoder:(NSString *)placehoder andAccessroy:(BOOL )assessory;
{
    
    return  [[self alloc] initWithPlacehoder:placehoder andAccessroy:assessory];
}

-(instancetype)initWithPlacehoder:(NSString *)placehoder andAccessroy:(BOOL)assessory
{
    self = [super init];
    if (self) {
        
        self.placeholder = placehoder;
        self.Accessory = assessory;
    }
    return self;
}
@end
