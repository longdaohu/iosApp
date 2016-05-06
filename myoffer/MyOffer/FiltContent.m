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

-(instancetype)initItemWithTitle:(NSString *)titleName andDetailTitle:(NSString *)detailName anditems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.titleName =titleName;
        self.detailTitleName = detailName;
        self.buttonArray = [items mutableCopy];
        [self getContentHigh:items];
         self.cellHiden = NO;
    }
    return self;

}

+(instancetype)createItemWithTitle:(NSString *)titleName andDetailTitle:(NSString *)detailName anditems:(NSArray *)items
{
    return [[self alloc] initItemWithTitle:titleName andDetailTitle:detailName anditems:items];
}


-(void)getContentHigh:(NSArray *)items;
{
    //第一个 label的起点
    CGSize startSize = CGSizeMake(0, 10);
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = [UIScreen  mainScreen].bounds.size.width - 30;
    
    for (int i = 0; i < items.count; i ++) {
      
         CGFloat keyWordWidth = [items[i] KD_sizeWithAttributeFont:[UIFont systemFontOfSize:18]].width +15;
        
        if (keyWordWidth > MAXWidth) {
            
            keyWordWidth = MAXWidth;
        }
        if (MAXWidth - startSize.width < keyWordWidth) {
            
            startSize.height += 35.0;
            
            startSize.width = 0;
        }
        
        //起点 增加
        startSize.width += keyWordWidth + padding;
    }

        
     self.contentheigh = startSize.height +35;

}

 

@end
