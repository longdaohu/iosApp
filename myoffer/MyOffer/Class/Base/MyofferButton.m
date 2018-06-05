//
//  MyofferButton.m
//  newOffer
//
//  Created by xuewuguojie on 2018/2/24.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "MyofferButton.h"

@implementation MyofferButton


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
    self.icon_percent = 0.6;
    /*
     如果需要多行显示，可以设置下面属性
     self.titleLabel.numberOfLines = 2;
     */
}


- (void)layoutSubviews{
    
    [super layoutSubviews];

    
    CGSize  contentSize = self.bounds.size;
    CGRect titleRect  = self.titleLabel.frame;
    CGRect imageeRect  = self.imageView.frame;
    
    // 必须有图片和文字
    if (0  == self.currentTitle.length || 0  == self.currentImage.size.width ) return;

 
    switch (self.type) {
        case MyofferButtonTypeImageLeft:
        {
            /*
             *   1 如果没有设置图片和文字之间的间隙
             *   2 如果图片宽或文字高于父控件时      特殊情况不特别处理
             */
            if (imageeRect.size.width > contentSize.height || titleRect.size.height > contentSize.height) return;
            
            if (self.margin_between == 0) return;
            
            CGFloat all_margin = imageeRect.origin.x * 2 ;
            
            if (self.margin_between + 4 <=  all_margin ) {

                CGFloat left_padding = (all_margin - self.margin_between) * 0.5;
                imageeRect.origin.x = left_padding;
                titleRect.origin.x =  imageeRect.origin.x + imageeRect.size.width + self.margin_between;
                self.titleLabel.frame = titleRect;
                self.imageView.frame = imageeRect;
               // layoutSubviews 会多次刷新， 还原margin_between  防止多次刷新
                self.margin_between = 0;
            }
            
        }
            break;
        case MyofferButtonTypeImageRight:{
            

            //要求图片高小于父控件的高，否则会达不到显示效果
            //当文字在图片左边时，不再重新设置
            if (self.imageView.mj_x > self.titleLabel.mj_x) return;
            
            if (self.margin_between == 0) {
                
                titleRect.origin.x =  imageeRect.origin.x;
                imageeRect.origin.x = titleRect.origin.x + titleRect.size.width;
                self.titleLabel.frame = titleRect;
                self.imageView.frame = imageeRect;
                
                return;
            }
            
            CGFloat all_margin = imageeRect.origin.x * 2 ;
            
            if (self.margin_between + 4 <=  all_margin ) {
                
                CGFloat left_padding = (all_margin - self.margin_between) * 0.5;
                titleRect.origin.x   = left_padding;
                imageeRect.origin.x =  titleRect.origin.x + titleRect.size.width + self.margin_between;
                self.titleLabel.frame = titleRect;
                self.imageView.frame = imageeRect;
                
            }
  
        }
            break;
        case  MyofferButtonTypeImageBottom:{
            
            //当文字在图片下边时，不再重新设置
            if (CGRectGetMaxY(self.imageView.frame) -  self.titleLabel.mj_y > self.imageView.mj_h) return;
            
            if (self.margin_between == 0) {
 
                titleRect.origin.y = 0 ;
                titleRect.origin.x = 0;
                titleRect.size.width = contentSize.width;
                titleRect.size.height = contentSize.height * 0.4;
                self.titleLabel.frame = titleRect;
                
                imageeRect.size.height = contentSize. height * 0.6;
                imageeRect.size.width = contentSize.width;
                imageeRect.origin.y  = titleRect.size.height;
                imageeRect.origin.x  = 0;
                self.imageView.frame = imageeRect;
                
                return;
            }
            
            imageeRect.origin.x  = 0;
            imageeRect.size.height = contentSize. height * 0.6;
            imageeRect.size.width = contentSize.width;
            
            titleRect.origin.x = 0;
            titleRect.size.width = contentSize.width;
            titleRect.size.height = self.titleLabel.mj_h;
            
            CGFloat margin_to_title = self.margin_between * contentSize. height;
            
            //大于1时设置固定大小间距
            if (self.margin_between >= 1) margin_to_title = self.margin_between;
            
            //可用最大间距
            CGFloat max_margin = contentSize.height - imageeRect.size.height - titleRect.size.height;
            
            if(margin_to_title >= max_margin)  margin_to_title =  max_margin;
            
            CGFloat top_margin_bottom =  max_margin  - margin_to_title;
            top_margin_bottom = top_margin_bottom <= 0 ? 0 : top_margin_bottom;
            titleRect.origin.y  =  top_margin_bottom * 0.5;
            imageeRect.origin.y =  titleRect.size.height + titleRect.origin.y  + margin_to_title;
            self.titleLabel.frame = titleRect;
            self.imageView.frame = imageeRect;
        }
            break;
        case MyofferButtonTypeImageTop:{
            
            //当文字在图片下边时，不再重新设置
            if (self.titleLabel.mj_y - self.imageView.mj_y  >= self.imageView.mj_h) return;
 
            if (self.margin_between == 0) {

                imageeRect.size.height = contentSize.height * self.icon_percent;
                imageeRect.size.width = contentSize.width;
                imageeRect.origin.y  = 0;
                imageeRect.origin.x  = 0;
                self.imageView.frame = imageeRect;
                
                titleRect.origin.y  =  imageeRect.size.height + imageeRect.origin.y ;
                titleRect.origin.x = 0;
                titleRect.size.width = contentSize.width;
                titleRect.size.height = contentSize.height * (1 - self.icon_percent);
                self.titleLabel.frame = titleRect;
                
                return;
            }
            
            imageeRect.origin.x  = 0;
            imageeRect.size.height = contentSize. height * self.icon_percent;
            imageeRect.size.width = contentSize.width;
            
            titleRect.origin.x = 0;
            titleRect.size.width = contentSize.width;
            titleRect.size.height = self.titleLabel.mj_h;
            
            
            CGFloat margin_to_title = self.margin_between * contentSize. height;
            
            //大于1时设置固定大小间距
            if (self.margin_between >= 1) margin_to_title = self.margin_between;
            
            //可用最大间距
            CGFloat max_margin = contentSize. height - imageeRect.size.height - titleRect.size.height;
            
            if(margin_to_title >= max_margin)  margin_to_title =  max_margin;
 
            CGFloat top_margin_bottom =  max_margin  - margin_to_title;
            top_margin_bottom = top_margin_bottom <= 0 ? 0 : top_margin_bottom;
            imageeRect.origin.y =  top_margin_bottom * 0.5;
            titleRect.origin.y  =  imageeRect.size.height + imageeRect.origin.y  + margin_to_title;
            
            self.titleLabel.frame = titleRect;
            self.imageView.frame = imageeRect;

        }
            break;
        default:
            break;
    }
    
}

@end
