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
    

    for (YSCourseModel *item in self.items) {

        if ( item.courseState ==  YSCourseModelVideoStateFINISHED || item.courseState ==  YSCourseModelVideoStateEXPIRED ) {
            [FINISHED_tmp addObject:item];
        }else{
            [IN_PROGRESS_tmp addObject:item];
        }
    }
    self.IN_PROGRESS = [IN_PROGRESS_tmp copy];
    self.FINISHED = [FINISHED_tmp copy];
}


 /*
 
 
 result =     (
 {
 classId = 5b92140d9a8fbc2ceac18d66;
 count = 6;
 endTime = "2018-09-11";
 isLiving = 1;
 label = "\U4eca\U5929 09:00:00";
 name = "\U96c5\U601d7\U5206\U51b2\U523a\U73ed";
 nextCourseEndTime = "2018-09-11T03:00:00.000Z";
 nextCourseStartTime = "2018-09-11T01:00:00.000Z";
 productImg = "";
 startTime = "2018-08-06";
 status = "IN_PROGRESS";
 total = 6;
 },
 
 
 
 {
 classId = 5b92222d845d8422a6e498fa;
 count = 2;
 endTime = "2018-08-11";
 isLiving = 0;
 label = "";
 name = "\U96c5\U601d6\U5206\U63d0\U9ad8\U73ed";
 nextCourseEndTime = "<null>";
 nextCourseStartTime = "<null>";
 productImg = "";
 startTime = "2018-08-05";
 status = EXPIRED;
 total = 2;
 },
 
 
 
 {
 classId = 5b9729539a207277dc846711;
 count = 0;
 endTime = "2018-09-12";
 isLiving = 0;
 label = "\U660e\U5929 07:00:00";
 name = "\U96c5\U601d7\U5206\U51b2\U523a\U73ed";
 nextCourseEndTime = "2018-09-12T01:00:00.000Z";
 nextCourseStartTime = "2018-09-11T23:00:00.000Z";
 productImg = "";
 startTime = "2018-09-12";
 status = "NOT_START";
 total = 1;
 },
 
 
 
 
 {
 classId = 5b972aa09a207277dc846713;
 count = 1;
 endTime = "2018-09-11";
 isLiving = 1;
 label = "\U4eca\U5929 09:00:00";
 name = "\U96c5\U601d5\U5206\U57fa\U7840\U73ed";
 nextCourseEndTime = "2018-09-11T03:00:00.000Z";
 nextCourseStartTime = "2018-09-11T01:00:00.000Z";
 productImg = "";
 startTime = "2018-09-11";
 status = "IN_PROGRESS";
 total = 1;
 }
 );
 
 

 */


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
