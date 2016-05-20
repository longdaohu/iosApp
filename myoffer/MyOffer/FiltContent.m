//
//  filtercontent.m
//  TESTER
//
//  Created by xuewuguojie on 15/12/15.
//  Copyright © 2015年 xuewuguojie. All rights reserved.
//

#import "FiltContent.h"
#import "FilterSection.h"

@implementation FiltContent



+(instancetype)createItemWithTitle:(NSString *)titleName andDetailTitle:(NSString *)detailName anditems:(NSArray *)items
{
    return [[self alloc] initItemWithLogoName:nil titleName:titleName andDetailTitleName:detailName anditems:items];
}


+(instancetype)filterItemWithLogoName:(NSString *)logoName titleName:(NSString *)title detailTitleName:(NSString *)detailTitle anditems:(NSArray *)items
{
    return [[self alloc] initItemWithLogoName:logoName titleName:title andDetailTitleName:detailTitle anditems:items];
}


-(instancetype)initItemWithLogoName:(NSString *)logo  titleName:(NSString *)title andDetailTitleName:(NSString *)detailtitle anditems:(NSArray *)items
{
    
    self = [super init];
    if (self) {
        
        
        self.logoName = logo;
        self.titleName = title;
        self.detailTitleName = detailtitle;
        self.buttonArray = items;
        
        
    }
    return self;
}





@end
