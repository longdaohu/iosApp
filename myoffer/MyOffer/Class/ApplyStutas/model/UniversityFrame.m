//
//  UniversityFrame.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/31.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityFrame.h"
#import "MyOfferUniversityModel.h"
@implementation UniversityFrame


-(void)setUniversity:(MyOfferUniversityModel *)university{

    _university = university;
 
    CGFloat icon_X = 50;
    CGFloat icon_Y = 10;
    CGFloat icon_W =  80 + XFONT_SIZE(1) * 5;
    CGFloat icon_H = icon_W;
    self.icon_Frame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
    
    self.cell_Height = CGRectGetMaxY(self.icon_Frame) + icon_Y;

    
    CGFloat title_x = CGRectGetMaxX(self.icon_Frame) + 12;
    CGFloat title_y = icon_Y;
    CGFloat title_h = XFONT_SIZE(17);
    CGFloat title_w = XSCREEN_WIDTH - title_x;
    self.name_Frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    
    CGFloat official_X = title_x;
    CGFloat official_Y = CGRectGetMaxY(self.name_Frame) + 2;
    CGFloat official_W = title_w;
    CGFloat official_H =  XFONT_SIZE(13);
    self.official_Frame = CGRectMake(official_X, official_Y, official_W, official_H);
   
    
    CGFloat address_X =  official_X;
    CGFloat address_H =  XFONT_SIZE(13);
    CGFloat address_W =  official_W ;
    CGFloat address_Y =  self.cell_Height - 12 - address_H;
    self.address_Frame = CGRectMake(address_X, address_Y, address_W, address_H);
    
    
    CGFloat rank_H = address_H;
    CGFloat rank_X = address_X;
    CGFloat rank_Y = CGRectGetMaxY(self.official_Frame) + (address_Y - CGRectGetMaxY(self.official_Frame) - rank_H) * 0.5;
    CGFloat rank_W = address_W;
    self.rank_Frame = CGRectMake(rank_X, rank_Y, rank_W, rank_H);
    
 
    CGSize rankSize = [@"世界排名：" KD_sizeWithAttributeFont:XFONT(13)];
    CGFloat starBg_H = 15;
    CGFloat starBg_Y = rank_Y - (starBg_H - rank_H);
    self.starBgFrame = CGRectMake(rank_X + rankSize.width + 8,starBg_Y, 100, starBg_H);
    
    NSMutableArray *temps =[NSMutableArray array];
    for (NSInteger i =0; i < 5; i++) {
        
        NSString *x = [NSString stringWithFormat:@"%ld", (long)(20 * i)];
        
        [temps addObject: x];
    }
    self.starFrames = [temps copy];
    
}





@end


