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
    sectionM.show_All_data = YES;
    sectionM.limit_count = 5;
    
    return sectionM;
}



- (void)setShow_All_data:(BOOL)show_All_data{

    _show_All_data = show_All_data;
    
    //1 true 时展示全部
    if (show_All_data) {
        
        self.items = self.item_all;
        
        return;
    }
    
    
    //2 当fault && 全部数据小于限制数时，把show_All_data = true
    if (!show_All_data && self.item_all.count <= self.limit_count) {
        
        self.show_All_data = YES;
  
        return;
    }
    
    //2 当show_All_data == fault && (self.item_all.count > self.limit_count)时，展示部分数据

    if (self.item_all.count > self.limit_count) {
        
        self.items = [self.item_all subarrayWithRange:NSMakeRange(0,self.limit_count)];
        
    }else{
    
        self.items = self.item_all;

    }
    
  
    
}


@end
