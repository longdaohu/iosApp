//
//  HMTitleButton.m
//  黑马微博
//
//  Created by apple on 14-7-4.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMTitleButton.h"

@implementation HMTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内部图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字对齐
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        // 文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 字体
        self.titleLabel.font = [UIFont systemFontOfSize:KDUtilSize(16)];
        // 高亮的时候不需要调整内部的图片为灰色
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

/**
 *  设置内部图标的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.height;
    CGFloat imageH = imageW;
    CGFloat imageX = self.bounds.size.width - imageW;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

/**
 *  设置内部文字的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleX = 0;
    CGFloat titleH = self.bounds.size.height;
    CGFloat titleW = self.bounds.size.width - self.bounds.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 1.计算文字的尺寸
    CGSize titleSize = [title sizeWithFont:self.titleLabel.font];
    
    // 2.计算按钮的宽度
    CGRect newRect = self.frame;
    newRect.size.width = titleSize.width + self.bounds.size.height + 30;
    self.frame = newRect;
}

@end
