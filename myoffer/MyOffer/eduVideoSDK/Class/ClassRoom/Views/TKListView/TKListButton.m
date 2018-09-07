//
//  TKListButton.m
//  EduClass
//
//  Created by lyy on 2018/4/23.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKListButton.h"

@implementation TKListButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat titleY = contentRect.size.height/2.0;
    CGFloat titleX = 0;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height/2.0;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
    
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageX = 0;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
