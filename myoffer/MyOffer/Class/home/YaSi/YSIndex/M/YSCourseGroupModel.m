//
//  YSCourseGroupModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSCourseGroupModel.h"
#import "YSCourseModel.h"

@implementation YSCourseGroupModel

-  (void)setItems:(NSArray *)items{
    _items = items;
    
    NSMutableArray *IN_PROGRESS_tmp = [NSMutableArray array];
    NSMutableArray *FINISHED_tmp = [NSMutableArray array];
    
    // NO_COURSE  NOT_START  IN_PROGRESS  FINISHED  EXPIRED
    for (YSCourseModel *item in self.items) {
        if ([item.status isEqualToString:@"FINISHED"] || [item.status isEqualToString:@"EXPIRED"]) {
            [FINISHED_tmp addObject:item];
        }else{
            [IN_PROGRESS_tmp addObject:item];
        }
    }
    self.IN_PROGRESS = [IN_PROGRESS_tmp copy];
    self.FINISHED = [FINISHED_tmp copy];
}

- (NSArray *)curent_items{
    
    if (self.type == YSCourseGroupTypeDefault) {
      return    self.IN_PROGRESS;
    }else{
      return    self.FINISHED;
    }
}

- (CGFloat)cell_height{
    
    if (self.type == YSCourseGroupTypeDefault) {
        return    111;
    }else{
        return    72;
    }
}


@end
