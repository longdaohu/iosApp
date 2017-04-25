//
//  UniversityCourseFrame.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "UniversityCourseFrame.h"

@implementation UniversityCourseFrame

+ (instancetype)frameWithCourse:(UniversityCourse *)course{

    UniversityCourseFrame *courseframe = [[UniversityCourseFrame alloc] init];
    
    courseframe.course = course;
    
    return  courseframe;
}

- (void)setCourse:(UniversityCourse *)course{

    _course = course;
    
    
    CGFloat option_W =  60;
    CGFloat option_X =  XSCREEN_WIDTH - option_W;
    CGFloat option_Y =  0;

    CGFloat official_X =  10;
    CGFloat official_Y =  20;
    CGFloat official_W =  option_X - official_X;
    CGSize offical_Size  = [course.official_name KD_sizeWithAttributeFont:XFONT(14)];
    CGFloat official_maxHeight =  14 * 2.5;
    CGFloat official_H = offical_Size.width > official_W ? official_maxHeight : 16;
    self.official_name_Frame = CGRectMake(official_X, official_Y, official_W, official_H);
    
    
    CGFloat bg_X =  10;
    CGFloat bg_Y =  official_Y + official_maxHeight + 10;
    CGFloat bg_W =  official_W;
    CGFloat bg_H =  20;
    self.items_bg_Frame = CGRectMake(bg_X, bg_Y, bg_W, bg_H);
    
    self.cell_Height = CGRectGetMaxY(self.items_bg_Frame) + 20;

    
    CGFloat option_H =  self.cell_Height;
    self.option_Frame = CGRectMake(option_X, option_Y, option_W, option_H);
    
    
    CGFloat item_X = 0;
    CGFloat item_Y = 0;
    CGFloat item_H = bg_H;
    CGFloat item_W = 0;
    NSMutableArray *temps_item = [NSMutableArray array];
    
    for (NSInteger index = 0; index < course.tags.count; index++) {
        
        CGSize item_Size  = [course.tags[index] KD_sizeWithAttributeFont:XFONT(11)];
        item_W = item_Size.width + 10;
        CGRect item_rect = CGRectMake(item_X, item_Y, item_W, item_H);
        item_X += (item_W + 10);
        
        [temps_item  addObject:[NSValue valueWithCGRect:item_rect]];
    }
    
    self.items_Frame = [temps_item copy];
  
}


@end
