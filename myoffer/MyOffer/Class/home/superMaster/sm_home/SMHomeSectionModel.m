//
//  SMHomeItem.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMHomeSectionModel.h"

@implementation SMHomeSectionModel

+ (instancetype)sectionInitWithTitle:(NSString *)title Items:(NSArray *)items  groupType:(SMGroupType)groupType{

    SMHomeSectionModel *sectionM = [[SMHomeSectionModel alloc] init];
    sectionM.item_all = items;
    sectionM.groupType = groupType;
    sectionM.title = title;
    sectionM.showAll = YES;
    sectionM.limit_count = 5;
    
    return sectionM;
}


- (void)setShowAll:(BOOL)showAll{

    _showAll = showAll;
    
    if (showAll) {
        
        self.items = self.item_all;

        return;
    }
    
    
    if (!showAll && self.item_all.count <= self.limit_count) {
        
        
        self.showAll = YES;
        
        return;
    }
    
    
    NSArray *tmp_Arr = self.item_all.count > self.limit_count ? [self.item_all subarrayWithRange:NSMakeRange(0,self.limit_count)]: self.item_all;
    self.items = tmp_Arr;
    
}



@end
