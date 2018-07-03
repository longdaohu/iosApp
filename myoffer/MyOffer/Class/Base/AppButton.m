//
//  AppButton.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "AppButton.h"

@implementation AppButton

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
    /*
     如果需要多行显示，可以设置下面属性
     self.titleLabel.numberOfLines = 2;
     */
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    //没有图标或标题 不需要重新设置
    if  (self.currentImage == nil || self.currentTitle == nil){
        return;
    }
    CGSize content_size = self.bounds.size;
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    CGFloat image_w = self.imageView.mj_w;
    CGFloat image_h = self.imageView.mj_h;
    if (self.image_width > 0) {
        image_w = self.image_width;
        image_h =  image_h * image_w /self.imageView.mj_w;
    }
    CGFloat title_w = self.titleLabel.mj_w;
    CGFloat title_h = self.titleLabel.mj_h;
    
    switch (self.type) {
        case MyofferButtonTypeImageTop:
        {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;

            if(self.margin > 0){
    
                CGFloat max_margin = (content_size.height - image_h - title_h);
                if (self.margin > max_margin) {
                    self.margin = max_margin;
                }
                CGFloat up_down_margin = max_margin - self.margin;
                imageFrame.origin.x = 0.5 * (content_size.width - image_w);
                imageFrame.origin.y = up_down_margin * 0.5;
                self.imageView.frame = imageFrame;
                titleFrame.origin.x = 0;
                titleFrame.origin.y = (CGRectGetMaxY(self.imageView.frame)  + self.margin);
                titleFrame.size.width = content_size.width;
                self.titleLabel.frame = titleFrame;
                
            }else{
                
                imageFrame.origin.x = 0.5 * (content_size.width - image_w);
                imageFrame.origin.y = (content_size.height - image_h - title_h)*0.5;
                self.imageView.frame = imageFrame;
                
                titleFrame.origin.x = 0;
                titleFrame.origin.y = CGRectGetMaxY(self.imageView.frame);
                titleFrame.size.width = content_size.width;
                self.titleLabel.frame = titleFrame;
            }
 
        }
            break;
        case MyofferButtonTypeImageBottom:{
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            if(self.margin > 0){
                CGFloat max_margin = (content_size.height - image_h - title_h);
                if (self.margin > max_margin) {
                    self.margin = max_margin;
                }
                CGFloat up_down_margin = max_margin - self.margin;
                
                titleFrame.origin.x = 0;
                titleFrame.origin.y =  up_down_margin * 0.5;
                titleFrame.size.width = content_size.width;
                self.titleLabel.frame = titleFrame;
                
                imageFrame.origin.x = 0.5 * (content_size.width - image_w);
                imageFrame.origin.y =  CGRectGetMaxY(self.titleLabel.frame) + self.margin;
                self.imageView.frame = imageFrame;
                
            }else{
                
                titleFrame.origin.x = 0;
                titleFrame.origin.y =  (content_size.height - image_h - title_h)*0.5;
                titleFrame.size.width = content_size.width;
                self.titleLabel.frame = titleFrame;
                
                imageFrame.origin.x = 0.5 * (content_size.width - image_w);
                imageFrame.origin.y =  CGRectGetMaxY(self.titleLabel.frame);
                self.imageView.frame = imageFrame;
                
            }
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
                self.titleLabel.frame = titleFrame;
                imageFrame.origin.x =  CGRectGetMaxX(self.titleLabel.frame) + self.margin;
                self.imageView.frame = imageFrame;
                
            }else{
                
                titleFrame.origin.x = max_margin * 0.5;
                self.titleLabel.frame = titleFrame;
                imageFrame.origin.x =  CGRectGetMaxX(self.titleLabel.frame) ;
                self.imageView.frame = imageFrame;
            }
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

