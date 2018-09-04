//
//  YXDayCell.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXDayCell.h"

@interface YXDayCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayL;     //日期
@property (weak, nonatomic) IBOutlet UIView *pointV;    //点

@end

@implementation YXDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _pointV.layer.cornerRadius = 3;
}

//MARK: - setmethod

- (void)setCellDate:(NSDate *)cellDate {
    _cellDate = cellDate;
    if (_type == CalendarType_Week) {
        [self showDateFunction];
    } else {
        if ([[YXDateHelpObject manager] checkSameMonth:_cellDate AnotherMonth:_currentDate]) {
            [self showDateFunction];
        } else {
            [self showSpaceFunction];
        }
    }
}

- (void)setEventArray:(NSArray *)eventArray{
    _eventArray = eventArray;
    
    
    [self showDateFunction];
}

//MARK: - otherMethod

- (void)showSpaceFunction {
    self.userInteractionEnabled = NO;
    _dayL.text = @"";
    _dayL.backgroundColor = [UIColor clearColor];
    _pointV.hidden = YES;
}

- (void)showDateFunction {
    
    self.userInteractionEnabled = YES;
    
    _dayL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"d" Date:_cellDate];
    
    if (_selectDate) {
        
        if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:_selectDate]) {
           
            _dayL.backgroundColor = [UIColor blackColor];
            _dayL.textColor = [UIColor whiteColor];
            _pointV.backgroundColor = [UIColor whiteColor];
            if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:[NSDate date]]) {
                _dayL.backgroundColor = XCOLOR_LIGHTBLUE;
            }
            
        } else {
            
            _dayL.backgroundColor = [UIColor clearColor];
            _pointV.backgroundColor = [UIColor blackColor];
            if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:[NSDate date]]) {
                _dayL.textColor = XCOLOR_LIGHTBLUE;
            } else {
                _dayL.textColor = [UIColor blackColor];
            }
        }
    }
    //设置年月日时间是否与传入事件 _eventArray 时间匹配 -08-
    NSString *currentDate = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:self.cellDate];
    self.pointV.hidden = YES;
    if (self.eventArray.count > 0) {
        if ([self.eventArray containsObject:currentDate]) {
            self.pointV.hidden = NO;
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.dayL.layer.cornerRadius = self.dayL.frame.size.height * 0.5;
}


@end
