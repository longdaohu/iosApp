//
//  SearchUniCourseFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/2.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SearchUniCourseFrame.h"

@implementation SearchUniCourseFrame


+ (instancetype)frameWithCourse:(UniversityCourse *)course{
    
    SearchUniCourseFrame *courseframe = [[SearchUniCourseFrame alloc] init];
    
    courseframe.course = course;
    
    return  courseframe;
}


- (void)setCourse:(UniversityCourse *)course{
    
    _course = course;

    
    CGFloat official_X =  10;
    CGFloat official_Y =  10;
    CGFloat official_W =   XSCREEN_WIDTH -  2 * official_X;
    CGSize offical_Size  = [course.official_name KD_sizeWithAttributeFont:XFONT(14) maxWidth:official_W];
    CGFloat official_H = offical_Size.height;
    self.official_name_Frame = CGRectMake(official_X, official_Y, official_W, official_H);
    
    
    CGFloat bg_X =  10;
    CGFloat bg_Y =  official_Y + official_H + 10;
    CGFloat bg_W =  official_W;

    
    
    NSMutableArray *temps =[NSMutableArray array];
    
    //第一个 label的起点
    CGSize startSize = CGSizeMake(0, 0);
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = [UIScreen  mainScreen].bounds.size.width - 20;
    
    for (int i = 0; i < course.tags.count; i ++) {
        
        CGFloat keyWordWidth = [course.tags[i] KD_sizeWithAttributeFont:[UIFont systemFontOfSize:11]].width + 10;
        
        if (keyWordWidth > MAXWidth) {
            
            keyWordWidth = MAXWidth;
        }
        
        if (MAXWidth - startSize.width < keyWordWidth) {
            
            startSize.height += 30.0;
            
            startSize.width = 0;
        }
        
        
        CGRect itemRect = CGRectMake(startSize.width, startSize.height, keyWordWidth, 20);
        
        [temps addObject:[NSNumber valueWithCGRect:itemRect]];
        
        //起点 增加
        startSize.width += keyWordWidth + padding;
        
    }
    
    
    self.items_Frame = [temps copy];
    CGFloat bg_H  = 0;

    if (course.tags.count) {
        
       NSNumber *last =  self.items_Frame.lastObject;
        
        bg_H = CGRectGetMaxY(last.CGRectValue);
    }
    
    self.items_bg_Frame = CGRectMake(bg_X, bg_Y, bg_W, bg_H);
    
    self.cell_Height = course.tags.count ? CGRectGetMaxY(self.items_bg_Frame) + 5 :  CGRectGetMaxY(self.official_name_Frame) + 5;
    
}






@end
