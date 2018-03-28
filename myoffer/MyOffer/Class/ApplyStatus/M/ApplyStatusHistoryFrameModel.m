//
//  ApplyStatusHistoryFrameModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStatusHistoryFrameModel.h"

@implementation ApplyStatusHistoryFrameModel


- (void)setStatusModel:(ApplyStutasModel *)statusModel{
    
 
    _statusModel = statusModel;
    
    CGFloat padding = 15;
 
    CGFloat title_x = padding + 5;
    CGFloat title_y = padding;
    CGFloat title_w = XSCREEN_WIDTH - title_x - padding;
    CGSize  titleSize = [statusModel.title KD_sizeWithAttribute:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} maxWidth:title_w];
    CGFloat title_h = titleSize.height;
    self.title_Frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    CGRect topframe = self.title_Frame;
    
    UIFont *subFont = [UIFont systemFontOfSize:12];

    if (statusModel.sub_title.length > 0) {
        
        CGFloat padding_x = title_x;
        CGFloat padding_h = subFont.lineHeight;
        CGFloat padding_w = 4;
        CGFloat padding_y = CGRectGetMaxY(self.title_Frame);
        self.paddingFrame = CGRectMake(padding_x, padding_y, padding_w, padding_h);
        
        CGFloat sub_x = CGRectGetMaxX(self.paddingFrame) + 5;
        CGFloat sub_y = CGRectGetMaxY(self.title_Frame) + 5;
        CGFloat sub_w = XSCREEN_WIDTH - sub_x - padding;
        CGSize sub_Size = [statusModel.sub_title  KD_sizeWithAttribute:@{NSFontAttributeName :subFont} maxWidth:sub_w];
        CGFloat sub_h = sub_Size.height;
        self.sub_titleFrame = CGRectMake(sub_x, sub_y, sub_w, sub_h);
    
        topframe = self.sub_titleFrame;
    }
 
    
    CGFloat tag_x = padding;
    CGFloat tag_y = CGRectGetMaxY(topframe) + 5;
    CGFloat tag_w = [statusModel.type KD_sizeWithAttributeFont:subFont].width + 10;
    CGFloat tag_h = subFont.lineHeight + 5;
    self.tagFrame = CGRectMake(tag_x, tag_y, tag_w, tag_h);
    
    self.header_height = CGRectGetMaxY(self.tagFrame) + padding;
    
}





@end
