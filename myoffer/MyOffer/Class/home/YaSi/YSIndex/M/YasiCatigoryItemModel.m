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
        if (self.course_description.count > 0) {
            [items_tmp addObject:self.course_description];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.course_outline.count > 0) {
            [items_tmp addObject:self.course_outline];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.asken_questions.count > 0) {
            [items_tmp addObject:self.asken_questions];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        if (self.notes_application.count > 0) {
            [items_tmp addObject:self.notes_application];
        }else{
            [items_tmp addObject:@[@"test"]];
        }
        
        _items = items_tmp;
    }
    
    return _items;
}



@end

