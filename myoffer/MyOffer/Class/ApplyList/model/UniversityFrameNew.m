//
//  UniversityFrameNew.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/5.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityFrameNew.h"
#import "UniversityNew.h"

@implementation UniversityFrameNew

+(instancetype)universityFrameWithUniverstiy:(UniversityNew *)universtiy{
    
    UniversityFrameNew *uniFrame = [[UniversityFrameNew alloc] init];
    
    uniFrame.universtiy = universtiy;
    
    return uniFrame;
}


-(void)setUniverstiy:(UniversityNew *)universtiy{

    _universtiy = universtiy;
    
    
    CGFloat icon_X = 10;
    CGFloat icon_Y = 10;
    CGFloat icon_W =  80 + XFONT_SIZE(1) * 5;
    CGFloat icon_H = icon_W;
    self.icon_Frame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
 
    self.cell_Height = CGRectGetMaxY(self.icon_Frame) + 10;
    
    
    
    CGFloat title_x = CGRectGetMaxX(self.icon_Frame) + 12;
    CGFloat title_y = icon_Y;
    CGFloat title_h = XFONT_SIZE(17);
    CGFloat title_w = XSCREEN_WIDTH - title_x;
    self.name_Frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    
    CGFloat official_X = title_x;
    CGFloat official_Y = CGRectGetMaxY(self.name_Frame) + 2;
    CGFloat official_W = title_w;
    CGSize  official_Size = [universtiy.official_name KD_sizeWithAttributeFont:XFONT(XFONT_SIZE(13))  maxWidth:official_W];
    CGFloat official_H =  official_Size.height;
    self.official_Frame = CGRectMake(official_X, official_Y, official_W, official_H);
    
 
    CGFloat anthor_X =  official_X;
    CGFloat anthor_H =  XFONT_SIZE(13);
    CGFloat anthor_W =  anthor_H;
    CGFloat anthor_Y =  self.cell_Height - 12 - anthor_H;
    self.anchor_Frame = CGRectMake(anthor_X, anthor_Y, anthor_W, anthor_H);
    
    CGFloat address_X =  CGRectGetMaxX(self.anchor_Frame) + 6;
    CGFloat address_H =  anthor_H;
    CGFloat address_W =  official_W - address_X;
    CGFloat address_Y =  anthor_Y;
    self.address_Frame = CGRectMake(address_X, address_Y, address_W, address_H);
    
    
    CGFloat rank_icon_X =  anthor_X;
    CGFloat rank_icon_H =  anthor_H;
    CGFloat rank_icon_W =  rank_icon_H;
    CGFloat rank_icon_Y =  CGRectGetMaxY(self.official_Frame) + (address_Y - CGRectGetMaxY(self.official_Frame) - rank_icon_H) * 0.5;
    self.rank_Icon_Frame = CGRectMake(rank_icon_X, rank_icon_Y, rank_icon_W, rank_icon_H);
    
    
    CGFloat rank_X = address_X;
    CGFloat rank_Y = rank_icon_Y;
    CGFloat rank_W = address_W;
    CGFloat rank_H = address_H;
    self.rank_Frame = CGRectMake(rank_X, rank_Y, rank_W, rank_H);
    
    
    CGSize rankSize = [@"世界排名：" KD_sizeWithAttributeFont:XFONT(12)];
    CGFloat starBg_H = 15;
    CGFloat starBg_Y = rank_Y - (starBg_H - rank_H);
    self.starBgFrame = CGRectMake(rank_X + rankSize.width ,starBg_Y, 100, starBg_H);
    
    NSMutableArray *temps =[NSMutableArray array];
    for (NSInteger i =0; i < 5; i++) {
        
        NSString *x = [NSString stringWithFormat:@"%ld", (long)(20 * i)];
        
        [temps addObject: x];
    }
    self.starFrames = [temps copy];
    
    
    CGFloat add_X = XSCREEN_WIDTH - 40;
    CGFloat add_Y = 0;
    CGFloat add_W = 30;
    CGFloat add_H = Uni_Cell_Height;
    self.add_Frame = CGRectMake(add_X,add_Y,add_W,add_H);
    
    
    CGFloat hot_H = 50;
    CGFloat hot_W = hot_H;
    CGFloat hot_X = XSCREEN_WIDTH - hot_H;
    CGFloat hot_Y = 0;
    self.hot_Frame = CGRectMake(hot_X,hot_Y, hot_W,hot_H);
    
    
    self.bottom_line_Frame = CGRectMake(10, self.cell_Height - 1, XSCREEN_WIDTH, 1);
    
    
    
    CGFloat cancel_x = ITEM_MARGIN;
    CGFloat cancel_y = 0;
    CGFloat cancel_h = self.cell_Height;
    CGFloat cancel_w = 34;
    self.cancel_Frame = CGRectMake(cancel_x, cancel_y, cancel_w, cancel_h);
    

}


/*
 
-(void)setUniverstiy:(UniversityNew *)universtiy{
    
    _universtiy = universtiy;

    
    CGFloat cancel_x = ITEM_MARGIN;
    CGFloat cancel_y = 0;
    CGFloat cancel_h = Uni_Cell_Height;
    CGFloat cancel_w = 34;
    self.cancel_Frame = CGRectMake(cancel_x, cancel_y, cancel_w, cancel_h);
    
    CGFloat sectionBgx = 0;
    CGFloat sectionBgy = 0;
    CGFloat sectionBgh = Uni_Cell_Height;
    CGFloat sectionBgw = XSCREEN_WIDTH;
    self.SectionBackgroudFrame = CGRectMake(sectionBgx,sectionBgy, sectionBgw, sectionBgh);
    
    
    CGFloat icon_X = ITEM_MARGIN;
    CGFloat icon_Y = ITEM_MARGIN;
    CGFloat icon_W = Uni_Cell_Height - 2 * ITEM_MARGIN;
    CGFloat icon_H = icon_W;
    self.icon_Frame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
    
    
    CGFloat title_x = CGRectGetMaxX(self.icon_Frame) + ITEM_MARGIN;
    CGFloat title_y = icon_Y + 5;
    CGFloat title_h = Uni_address_FontSize;
    CGFloat title_w = XSCREEN_WIDTH - title_x;
    self.name_Frame = CGRectMake(title_x, title_y - 3, title_w, title_h);
    
    
    CGFloat official_X = CGRectGetMaxX(self.icon_Frame) + ITEM_MARGIN;
    CGFloat official_Y = CGRectGetMaxY(self.name_Frame) + 3;
    CGFloat official_W = XSCREEN_WIDTH - official_X - 45;
    CGFloat official_H =  Uni_subtitle_FontSize + 2;
    self.official_Frame = CGRectMake(official_X, official_Y, official_W, official_H);
    
    
    CGFloat anthor_X =  official_X;
    CGFloat anthor_H =  Uni_rank_FontSize + 5;
    CGFloat anthor_W =  anthor_H;
    CGFloat anthor_Y =  CGRectGetMaxY(self.icon_Frame) - anthor_H;
    self.anchor_Frame = CGRectMake(anthor_X, anthor_Y, anthor_W, anthor_H);
    
    CGFloat address_X =  CGRectGetMaxX(self.anchor_Frame) + 5;
    CGFloat address_H =  Uni_address_FontSize;
    CGFloat address_W =  official_W;
    CGFloat address_Y =  anthor_Y  + 3;
    self.address_Frame = CGRectMake(address_X, address_Y, address_W, address_H);
    
    
    CGFloat rank_W = official_W;
    CGFloat rank_H = Uni_rank_FontSize;
    
    CGFloat rank_icon_X =  official_X;
    CGFloat rank_icon_H =  Uni_rank_FontSize;
    CGFloat rank_icon_W =  anthor_H;
    CGFloat rank_icon_Y =  CGRectGetMaxY(self.official_Frame) + (address_Y - CGRectGetMaxY(self.official_Frame) - rank_H) * 0.5;
    self.rank_Icon_Frame = CGRectMake(rank_icon_X, rank_icon_Y, rank_icon_W, rank_icon_H);
    
    CGFloat rank_X = address_X;
    CGFloat rank_Y = rank_icon_Y;
    self.rank_Frame = CGRectMake(rank_X, rank_Y, rank_W, rank_H);
    
    
    NSString *rankIT  =[NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
    CGSize rankSize = [rankIT KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(UNIVERISITYLOCALFONT))];
    self.starBgFrame = CGRectMake(self.official_Frame.origin.x + rankSize.width , self.rank_Frame.origin.y, 100, 15);
    NSMutableArray *temps =[NSMutableArray array];
    for (NSInteger i =0; i < 5; i++) {
        
        NSString *x = [NSString stringWithFormat:@"%ld", (long)(20 * i)];
        
        [temps addObject: x];
    }
    self.starFrames = [temps copy];
    
    
    CGFloat add_X = XSCREEN_WIDTH - 40;
    CGFloat add_Y = 0;
    CGFloat add_W = 30;
    CGFloat add_H = Uni_Cell_Height;
    self.add_Frame = CGRectMake(add_X,add_Y,add_W,add_H);
    
    
    CGFloat hot_H = 50;
    CGFloat hot_W = hot_H;
    CGFloat hot_X = XSCREEN_WIDTH - hot_H;
    CGFloat hot_Y = 0;
    self.hot_Frame = CGRectMake(hot_X,hot_Y, hot_W,hot_H);
    
    
    self.bottom_line_Frame = CGRectMake(10, Uni_Cell_Height - 1, XSCREEN_WIDTH, 1);

    
}

*/

@end
