//
//  XUButton.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XUButton.h"

@implementation XUButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode =UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleH = contentRect.size.height;
    CGFloat  titleW = contentRect.size.width;

    return CGRectMake(titleX, titleY, titleW, titleH);

}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageW = 16;
    // 图片的X = 按钮的宽度 - 图片宽度
    CGFloat imageX = contentRect.size.width - imageW - 10;
    return CGRectMake(imageX, imageY, imageW, imageH);
}


@end
