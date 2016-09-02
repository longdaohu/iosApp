//
//  XmyShareButton.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "ShareButton.h"

@implementation ShareButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = XCOLOR_CLEAR;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:XCOLOR_DARKGRAY forState:UIControlStateNormal];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    return self;
}

+(instancetype)myShareButtonWithNormalTitle:( NSString *)normal_title seletedTitle:(NSString * )selected_title normalImage:(NSString *)normal_Image seletedImage:(NSString *)selected_Image actionType:(NSInteger)shareType
{
    
     ShareButton *myShare = [[ShareButton alloc] init];
    [myShare setTitle:normal_title forState:UIControlStateNormal];
      myShare.titleLabel.font = [UIFont systemFontOfSize:14 + FONT_SCALE];
    
    if (selected_title) {
        [myShare setTitle:selected_title forState:UIControlStateHighlighted];
    }
    
    [myShare setImage:[UIImage imageNamed:normal_Image] forState:UIControlStateNormal];
    if (selected_Image) {
        [myShare setImage:[UIImage imageNamed:selected_Image] forState:UIControlStateHighlighted];
    }
    
     myShare.tag = shareType;
 
    return myShare;

}


-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat titleY = contentRect.size.height *0.6;
    
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
    
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect

{
    
    CGFloat imageW = CGRectGetWidth(contentRect);
    
    CGFloat imageH = contentRect.size.height * 0.6;
    
    return CGRectMake(0, 0, imageW, imageH);
    
}

@end
