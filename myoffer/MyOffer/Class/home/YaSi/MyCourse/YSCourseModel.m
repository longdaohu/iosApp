//
//  YSCourseModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSCourseModel.h"

@implementation YSCourseModel

- (CGFloat)progress{
    
    if (!_progress) {
        
        _progress = self.count.floatValue/ self.total.floatValue;
    }
    
    return _progress;
}


- (NSString *)date_label{
    
    if (!_date_label) {
        
        NSArray *startTime =  [self.startTime componentsSeparatedByString:@"T"];
        NSArray *endTime =  [self.endTime componentsSeparatedByString:@"T"];
        
        if (startTime.count > 0 && endTime.count > 0) {
            _date_label = [NSString stringWithFormat:@"%@ —— %@  |  %@课时",startTime.firstObject,endTime.firstObject,self.total];
        }else{
            _date_label = [NSString stringWithFormat:@"%@课时",self.total];
        }
    }
    
    return _date_label;
}


@end

