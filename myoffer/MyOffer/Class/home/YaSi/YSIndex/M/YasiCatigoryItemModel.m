//
//  YasiCatigoryItemModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YasiCatigoryItemModel.h"

@implementation YasiCatigoryItemModel

- (NSArray *)items{
    
    
    if (!_items) {

        NSMutableArray *items_tmp = [NSMutableArray array];
        if (self.courseDescription.count > 0) {
            [items_tmp addObject:self.courseDescription];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.courseOutline.count > 0) {
            [items_tmp addObject:self.courseOutline];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.courseQuestions.count > 0) {
            [items_tmp addObject:self.courseQuestions];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.courseCaveats.count > 0) {
            [items_tmp addObject:self.courseCaveats];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        _items = items_tmp;
    }
    
    return _items;
}



@end

