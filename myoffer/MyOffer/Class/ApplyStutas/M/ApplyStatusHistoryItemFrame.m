//
//  ApplyStatusHistoryItemFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStatusHistoryItemFrame.h"

@implementation ApplyStatusHistoryItemFrame

+ (instancetype)frameWithHistoryItem:(ApplyStutasHistoryModel *)historyItem{

    ApplyStatusHistoryItemFrame *frame_history = [[ApplyStatusHistoryItemFrame alloc] init];
    frame_history.historyItem = historyItem;
    
    return frame_history;
}

- (void)setHistoryItem:(ApplyStutasHistoryModel *)historyItem{

    _historyItem = historyItem;
    
    CGFloat padding = 15;
    CGFloat margin = 10;
    
    CGFloat spod_w = 10;
    CGFloat spod_h = spod_w;
    CGFloat spod_x = padding - spod_w * 0.5;
    CGFloat spod_y = padding;
    self.spod_Frame = CGRectMake(spod_x, spod_y, spod_w, spod_h);
    
    CGFloat line_x = padding;
    CGFloat line_y = padding;
    CGFloat line_w = LINE_HEIGHT;
    CGFloat line_h = 100;
    self.line_Frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    
    CGFloat status_x = CGRectGetMaxX(self.line_Frame) + padding;
    CGFloat status_y = margin;
    UIFont *statusFont = [UIFont systemFontOfSize:14];
    CGFloat status_w = XSCREEN_WIDTH - status_x  - margin;
    CGFloat status_h = statusFont.lineHeight;
    self.status_Frame = CGRectMake(status_x, status_y, status_w, status_h);
    
    
    CGFloat date_x = status_x;
    CGFloat date_y =  CGRectGetMaxY(self.status_Frame);
    CGFloat date_w = status_w;
    UIFont *dateFont = [UIFont systemFontOfSize:12];
    CGFloat date_h = dateFont.lineHeight;
    self.date_Frame = CGRectMake(date_x, date_y, date_w, date_h);
    
    self.cell_Height = CGRectGetMaxY(self.date_Frame) + padding;

}




@end
