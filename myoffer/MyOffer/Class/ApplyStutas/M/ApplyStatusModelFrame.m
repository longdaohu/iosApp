//
//  ApplyStatusModelFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStatusModelFrame.h"

@implementation ApplyStatusModelFrame

+ (instancetype)frameWithStatusModel:(ApplyStutasModel *)statusModel{

    
    ApplyStatusModelFrame *frameModel = [[ApplyStatusModelFrame alloc] init];
    
    frameModel.statusModel = statusModel;
    
    
    return frameModel;
}

- (void)setStatusModel:(ApplyStutasModel *)statusModel{

    _statusModel = statusModel;
    
    CGFloat margin = 10;
    
    CGFloat date_w = 70;
    CGFloat date_h = 20;
    
    CGFloat status_x = margin;
    CGFloat status_y = margin;
    CGFloat status_w = date_w;
    UIFont *statusFont = [UIFont systemFontOfSize:13];
    CGSize statusSize = [statusModel.status sizeWithAttributes:@{NSFontAttributeName:statusFont}];
    CGFloat status_h =  statusSize.width > date_w ? statusFont.lineHeight * 2 :  statusFont.lineHeight;
    self.status_Frame = CGRectMake(status_x, status_y, status_w, status_h);
    
    CGFloat date_x =  status_x;
    CGFloat date_y =  status_y + statusFont.lineHeight * 2.5  +  margin * 2;
    self.date_Frame = CGRectMake(date_x, date_y, date_w, date_h);
    
    
    self.cell_Height = CGRectGetMaxY(self.date_Frame) + margin;
    
    
    
    CGFloat title_x = CGRectGetMaxX(self.status_Frame) + margin * 2;
    CGFloat title_y = status_y;
    CGFloat title_w = XSCREEN_WIDTH - margin - title_x;
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    CGSize titleSize = [statusModel.title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
    CGFloat title_h =  titleSize.width > title_w ? titleFont.lineHeight * 2 :  titleFont.lineHeight;
    self.title_Frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    
    CGFloat tag_H = date_h;
    CGFloat tag_w = 60;
    CGFloat tag_x = title_x;
    CGFloat tag_y = self.cell_Height - tag_H - margin;
    self.tag_Frame = CGRectMake(tag_x, tag_y, tag_w, tag_H);
    
    
    CGFloat pad_H = 14;
    CGFloat pad_w = 4;
    CGFloat pad_x = title_x;
    CGFloat distance = (tag_y -  CGRectGetMaxY(self.title_Frame) - pad_H) * 0.5;
    CGFloat pad_y =  CGRectGetMaxY(self.title_Frame) + distance;
    self.paddingFrame = CGRectMake(pad_x, pad_y, pad_w, pad_H);
    
     
    self.padding_bottom_distance = distance;
     
}



@end
