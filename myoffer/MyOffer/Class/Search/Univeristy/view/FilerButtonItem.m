//
//  Mybutton.m
//  cover
//
//  Created by sara on 16/5/12.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "FilerButtonItem.h"

@implementation FilerButtonItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView =[[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.image =[UIImage imageNamed:@"2arrows-still"];
        [self addSubview:self.imageView];
        
        self.titleLab =[[UILabel alloc] init];
        self.titleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLab];
        
        self.bgButton =[[UIButton alloc] initWithFrame:self.bounds];
        [self.bgButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        
    }
    
    
    return self;
}

-(void)setTitle:(NSString *)title
{
    self.titleLab.text = title;
    
    CGFloat imageY = 0;
    CGFloat imageH = self.bounds.size.height;
    CGFloat imageW = 20;
    
    CGFloat titleY = 0;
    CGFloat titleH = self.bounds.size.height;
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGFloat titleW = titleSize.width > self.bounds.size.width -imageW ?  self.bounds.size.width -imageW : titleSize.width;
    CGFloat titleX = 0.5 * (self.bounds.size.width - titleW - imageW);
  
    CGFloat imageX = titleX + titleW;
    
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
            
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
}

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

-(void)click:(UIButton *)sender
{
  
         sender.selected = !sender.selected;
        
        [self transformButton:sender];
        
        if ([self.delegate respondsToSelector:@selector(button:Click:)]) {
            
            [self.delegate button:self Click:sender];
        }
    
}



-(void)transformButton:(UIButton *)sender
{
   
     self.titleLab.textColor =  sender.selected ? XCOLOR_RED : [UIColor blackColor];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        self.imageView.transform = sender.selected ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
        
        self.animating = YES;
        
    } completion:^(BOOL finished) {
        
         self.animating = NO;
  
    }];
    
}



-(void)setSelected:(BOOL )selected
{
    
     _selected = selected;
    
    self.bgButton.selected = selected;
    
    [self transformButton:self.bgButton];
    
}


@end
