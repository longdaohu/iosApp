//
//  TJFooterFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "TJFooterFrame.h"

@implementation TJFooterFrame

- (void)setFooter_title:(NSString *)footer_title{

    _footer_title = footer_title;
    
    
    CGFloat selectX = ITEM_MARGIN;
    CGFloat selectY = ITEM_MARGIN;
    CGFloat selectW = 30;
    CGFloat selectH = 30;
    self.select_frame  = CGRectMake(selectX, selectY, selectW, selectH);
    
    
    CGFloat des_X = CGRectGetMaxY(self.select_frame) + 5;
    CGFloat des_Y = CGRectGetMinY(self.select_frame);
    CGFloat des_W =  XSCREEN_WIDTH - des_X - ITEM_MARGIN;
    
    CGSize titleSize =[footer_title boundingRectWithSize:CGSizeMake(des_W, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    
    CGFloat des_H = titleSize.height;
    
    self.title_frame =CGRectMake(des_X, des_Y, des_W, des_H);
    
    CGFloat sub_Y = des_H + des_Y + 25;
    
    self.sbm_frame = CGRectMake(25, sub_Y, XSCREEN_WIDTH - 50, 50);
    
    self.footer_frame = CGRectMake(0, 0,XSCREEN_WIDTH, CGRectGetMaxY(self.sbm_frame) + 25);
 

}

@end
