//
//  UniversityFrameNew.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/5.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityFrameNew.h"
#import "MyOfferUniversityModel.h"
#import "SearchUniCourseFrame.h"

@implementation UniversityFrameNew

+(instancetype)universityFrameWithUniverstiy:(MyOfferUniversityModel *)universtiy{
    
    UniversityFrameNew *uniFrame = [[UniversityFrameNew alloc] init];
    
    uniFrame.universtiy = universtiy;
    
    return uniFrame;
}


-(void)setUniverstiy:(MyOfferUniversityModel *)universtiy{

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
    
    
    CGFloat line_H = LINE_HEIGHT;
    CGFloat line_W = XSCREEN_WIDTH;
    CGFloat line_X = 10;
    CGFloat line_Y = self.cell_Height - line_H;
    self.bottom_line_Frame = CGRectMake(line_X, line_Y, line_W, line_H);
    
    
    
    CGFloat cancel_x = ITEM_MARGIN;
    CGFloat cancel_y = 0;
    CGFloat cancel_h = self.cell_Height;
    CGFloat cancel_w = 34;
    self.cancel_Frame = CGRectMake(cancel_x, cancel_y, cancel_w, cancel_h);
    

    if (universtiy.courses.count > 0) [self makeCourseFrameWithCourses:universtiy.courses];
    
}


- (void)makeCourseFrameWithCourses:(NSArray *)courses{

    
    NSMutableArray *temps = [NSMutableArray array];
    
    [courses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SearchUniCourseFrame *courseFrame = [SearchUniCourseFrame frameWithCourse: (UniversityCourse *)obj];
        
        [temps addObject:courseFrame];
    }];
    
    self.courseFrames = [temps copy];
}



@end
