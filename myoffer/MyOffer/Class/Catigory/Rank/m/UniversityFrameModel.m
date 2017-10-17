//
//  UniversityFrameModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//
//#import "UniversityFrameNew.h"
#import "ApplySectionHeaderView.h"

#import "UniversityFrameModel.h"

@implementation UniversityFrameModel

+ (instancetype)universityFrameWithUniverstiy:(MyOfferUniversityModel *)universtiy{
    
    UniversityFrameModel *uni_Frame = [[UniversityFrameModel alloc] init];
    
    uni_Frame.universityModel = universtiy;
    
    return uni_Frame;
}

- (void)setUniversityModel:(MyOfferUniversityModel *)universityModel{
    
    _universityModel = universityModel;
    
    CGFloat margin = 10;

    CGFloat icon_X = margin;
    CGFloat icon_Y = margin;
    CGFloat icon_W =  80 + XFONT_SIZE(1) * 5;
    CGFloat icon_H = icon_W;
    self.icon_Frame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
    
    CGFloat cell_h =  icon_H+ icon_X * 2;
    CGFloat cell_w =  XSCREEN_WIDTH;
    self.cell_Height = cell_h;
    self.cell_Frame = CGRectMake(0, 0, cell_w, cell_h);
    
    
    CGFloat name_x = CGRectGetMaxX(self.icon_Frame) + margin;
    CGFloat name_y = icon_Y;
    CGFloat name_h = XFONT_SIZE(17);
    CGFloat name_w = cell_w - name_x;
    self.name_Frame = CGRectMake(name_x, name_y, name_w, name_h);
    
    CGFloat official_x = name_x;
    CGFloat official_y = CGRectGetMaxY(self.name_Frame) + 2;
    CGFloat official_w = name_w;
    CGSize  official_Size = [universityModel.official_name KD_sizeWithAttributeFont:XFONT(XFONT_SIZE(13))  maxWidth:official_w];
    CGFloat official_h =  official_Size.height;
    self.official_Frame = CGRectMake(official_x, official_y, official_w, official_h);
 
    CGFloat address_x =  official_x;
    CGFloat address_h =  XFONT_SIZE(13);
    CGFloat address_w =  official_w ;
    CGFloat address_y =  cell_h - 12 - address_h;
    self.address_Frame = CGRectMake(address_x, address_y, address_w, address_h);
 
    CGFloat rank_h = address_h;
    CGFloat rank_x = address_x;
    CGFloat rank_y = CGRectGetMaxY(self.official_Frame) + (address_y - CGRectGetMaxY(self.official_Frame) - rank_h) * 0.5;
    CGFloat rank_w = address_w;
    self.rank_Frame = CGRectMake(rank_x, rank_y, rank_w, rank_h);
    
}

@end


