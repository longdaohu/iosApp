//
//  SMNewsFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMNewsFrame.h"

@implementation SMNewsFrame

+ (instancetype)frameWithHot:(SMHotModel *)news{
    
    SMNewsFrame *newsFrame = [[SMNewsFrame alloc] init];
    
    newsFrame.news = news;
    
    return newsFrame;
}

- (void)setNews:(SMHotModel *)news{

    _news = news;
    
    CGFloat Margin = 10;

    CGFloat cell_w = XSCREEN_WIDTH * 0.7;
 
    
    CGFloat icon_x = 0;
    CGFloat icon_y = 0;
    CGFloat icon_w = cell_w;
    CGFloat icon_h = icon_w * 0.51;
    self.icon_Frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    
    CGFloat title_x = Margin;
    CGFloat title_y = icon_h + Margin;
    CGFloat title_w = icon_w - title_x * 2;
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    CGSize  title_Size = [news.main_title  KD_sizeWithAttributeFont:titleFont maxWidth:title_w];
    CGFloat title_h = title_Size.height >= titleFont.lineHeight * 2 ? titleFont.lineHeight * 2 : titleFont.lineHeight;
    self.title_Frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    
    CGFloat play_w =  cell_w * 0.35;
    CGFloat play_x =  cell_w - play_w - Margin;
    CGFloat play_y =  title_y + titleFont.lineHeight * 2 + Margin;
 
    
    CGSize name_size  = [news.guest_name KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]];
    CGFloat name_x = title_x;
    CGFloat name_h = name_size.height;
    CGFloat name_y = play_y;
    CGFloat name_w = play_x - title_x;
    self.name_Frame = CGRectMake(name_x, name_y, name_w, name_h);
    
    
    CGFloat uni_w =  name_w;
    CGFloat uni_h =  name_h;
    CGFloat uni_y =  CGRectGetMaxY(self.name_Frame);
    CGFloat uni_x =  title_x;
    self.uni_Frame = CGRectMake(uni_x, uni_y, uni_w, uni_h);
    
 
    CGFloat play_h =  CGRectGetMaxY(self.uni_Frame) - play_y;
    self.play_Frame = CGRectMake(play_x, play_y, play_w, play_h);


    
    CGFloat cell_H =  CGRectGetMaxY(self.play_Frame) + Margin;
    self.cell_size =  CGSizeMake(cell_w, cell_H);
    
    self.cell_height = cell_H;
    
}


@end

