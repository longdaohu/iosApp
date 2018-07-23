//
//  AppButton.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyOfferButton.h"

@implementation MyOfferButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self fixSubView];
        
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self fixSubView];
    }
    return self;
}

- (void)fixSubView{
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.icon_height = 0;
    
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if  (self.currentImage == nil && self.currentTitle && self.title_y > 0){
        
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.origin.y = self.title_y;
        self.titleLabel.frame = titleFrame;
        return;
    }
    
    //没有图标或标题 不需要重新设置
    if  (self.currentImage == nil || self.currentTitle == nil){
        return;
    }
    
    CGSize content_size = self.bounds.size;
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    CGFloat image_w = self.imageView.mj_w;
    CGFloat image_h = self.imageView.mj_h;
    
    if (self.icon_height > 0) {
        image_h = self.icon_height;
    }
    
    CGFloat title_w = self.titleLabel.mj_w;
    CGFloat title_h = self.titleLabel.mj_h;
    if (self.margin < 0) self.margin = 0;
    
    switch (self.type) {
            
        case MyofferButtonTypeImageTop: case MyofferButtonTypeImageBottom:{
            
            imageFrame.origin.x = 0;
            imageFrame.size.width = content_size.width;
            imageFrame.size.height = image_h;
            
            titleFrame.origin.x = 0;
            titleFrame.size.width = content_size.width;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            CGFloat up_down_margin = 0;
            if (self.margin > 0) {
                
                CGFloat max_margin = (content_size.height - image_h - title_h);
                if (self.margin > max_margin) {
                    self.margin = max_margin;
                }
                up_down_margin = (max_margin - self.margin);
            }
            
            BOOL isTop =   (self.type ==  MyofferButtonTypeImageTop ) ;
            if (isTop) {
                
                if(self.margin > 0){
                    imageFrame.origin.y = up_down_margin * 0.5;
                    titleFrame.origin.y = (CGRectGetMaxY(imageFrame)  + self.margin);
                    
                }else{
                    
                    imageFrame.origin.y = (content_size.height - image_h - title_h)*0.5;
                    titleFrame.origin.y= CGRectGetMaxY(imageFrame);
                }
                
            }else{
                
                if(self.margin > 0){
                    titleFrame.origin.y =  up_down_margin * 0.5;
                    imageFrame.origin.y =  CGRectGetMaxY(titleFrame) + self.margin;
                }else{
                    titleFrame.origin.y =  (content_size.height - image_h - title_h)*0.5;
                    imageFrame.origin.y =  CGRectGetMaxY(titleFrame);
                }
            }
            
            if (self.icon_y > 0) {
                imageFrame.origin.y = self.icon_y;
            }
            
            if (self.title_y > 0) {
                titleFrame.origin.y = self.title_y;
            }
            
            self.imageView.frame = imageFrame;
            self.titleLabel.frame = titleFrame;
            
        }
            break;
            
        case MyofferButtonTypeImageRight:{
            
            CGFloat max_margin = (content_size.width - image_w - title_w);
            if(self.margin > 0){
                
                if (self.margin > max_margin) {
                    self.margin = max_margin;
                }
                CGFloat l_r_margin = max_margin - self.margin;
                titleFrame.origin.x = l_r_margin * 0.5;
                imageFrame.origin.x =  CGRectGetMaxX(titleFrame) + self.margin;
                
            }else{
                
                titleFrame.origin.x = max_margin * 0.5;
                imageFrame.origin.x =  CGRectGetMaxX(titleFrame);
            }
            
            self.titleLabel.frame = titleFrame;
            self.imageView.frame = imageFrame;
        }
            break;
        default:
            
            if(self.margin > 0){
                
                CGFloat max_margin = (content_size.width - image_w - title_w);
                if (self.margin > max_margin) {
                    self.margin = max_margin;
                }
                imageFrame.origin.x -= self.margin * 0.5;
                self.imageView.frame = imageFrame;
                
                titleFrame.origin.x +=  self.margin * 0.5;
                self.titleLabel.frame = titleFrame;
            }
            
            break;
    }
    
}



@end

