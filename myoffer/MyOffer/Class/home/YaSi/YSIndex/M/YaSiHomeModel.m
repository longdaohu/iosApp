//
//  YaSiHomeModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YaSiHomeModel.h"

@implementation YaSiHomeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.left_margin = 20;
        [self makeSubviewesFrame];
    }
    return self;
}

- (void)makeSubviewesFrame{
    
    CGFloat ys_x = self.left_margin;
    CGFloat ys_y = 20;
    CGFloat ys_w = 60;
    CGFloat ys_h = ys_w;
    self.ysBtn_frame = CGRectMake(ys_x, ys_y, ys_w, ys_h);
    
    CGFloat sg_btn_x = ys_x + ys_w + 20;
    CGFloat sg_btn_h = 20;
    CGFloat sg_btn_y = (ys_h - sg_btn_h) * 0.5  + ys_y;
    CGFloat sg_btn_w = 64;
    self.signedBtn_frame = CGRectMake(sg_btn_x, sg_btn_y, sg_btn_w, sg_btn_h);
 
    CGFloat sg_tt_x = sg_btn_x + sg_btn_w + 8;
    CGFloat sg_tt_h = sg_btn_h;
    CGFloat sg_tt_y = sg_btn_y;
    CGFloat sg_tt_w = XSCREEN_WIDTH - sg_tt_x;
    self.signTitle_frame = CGRectMake(sg_tt_x, sg_tt_y, sg_tt_w, sg_tt_h);
    
    CGFloat bg_btn_x = ys_x;
    CGFloat bg_btn_y = ys_y + ys_h + 20;
    CGFloat bg_btn_h = 30;
    CGFloat bg_btn_w = XSCREEN_WIDTH - bg_btn_x * 2;
    self.bgBtn_frame = CGRectMake(bg_btn_x, bg_btn_y, bg_btn_w, bg_btn_h);
    
    CGFloat clock_btn_h = 32;
    CGFloat clock_btn_w = clock_btn_h;
    CGFloat clock_btn_x = ys_x - 1;
    CGFloat clock_btn_y = bg_btn_y - 1;
    self.clockBtn_frame = CGRectMake(clock_btn_x, clock_btn_y, clock_btn_w, clock_btn_h);
    
    CGFloat onlineLab_h = bg_btn_h;
    CGFloat onlineLab_y = bg_btn_y;
    CGFloat onlineLab_x = clock_btn_x + clock_btn_w + 10;
    CGFloat onlineLab_w = bg_btn_w -  clock_btn_w - 10;
    self.onlineLab_frame = CGRectMake(onlineLab_x, onlineLab_y, onlineLab_w, onlineLab_h);
    

    CGFloat banner_x = 0;
    CGFloat banner_y = bg_btn_y + bg_btn_h + 20;
    CGFloat banner_w = XSCREEN_WIDTH - banner_x * 2;
    CGFloat banner_h = banner_w * 189.0/335;
    self.bannerView_frame = CGRectMake(banner_x, banner_y, banner_w, banner_h);

    self.header_banner_size = CGSizeMake(banner_w - 40, banner_h - 5);

    CGFloat line_banner_x = self.left_margin;
    CGFloat line_banner_y = banner_y + banner_h + 28;
    CGFloat line_banner_w = XSCREEN_WIDTH - line_banner_x * 2;
    CGFloat line_banner_h = 1;
    self.line_banner_frame = CGRectMake(line_banner_x, line_banner_y, line_banner_w, line_banner_h);

    
    CGFloat header_height =  (line_banner_y + line_banner_h);
    self.header_frame = CGRectMake(0, 0, XSCREEN_WIDTH, header_height);
    
    
    CGFloat bt_x = 0;
    CGFloat bt_w = XSCREEN_WIDTH;
    CGFloat bt_y = banner_y + 20;
    CGFloat bt_h =  header_height - bt_y;
    self.bottomView_frame = CGRectMake(bt_x, bt_y, bt_w, bt_h);
 
}




@end
