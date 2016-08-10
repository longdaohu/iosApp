//
//  XWGJNODATASHOWView.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJNODATASHOWView.h"

@interface XWGJNODATASHOWView ()
@property(nonatomic,strong)UIImageView *CenterImageView;
@property(nonatomic,strong)UILabel *ContentLabel;
@property(nonatomic,strong)UIView *bgView;

@end

@implementation XWGJNODATASHOWView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.bgView =[[UIView alloc] init];
        [self addSubview:self.bgView];
        
        self.CenterImageView = [[UIImageView alloc] init];
        self.CenterImageView.image = [UIImage imageNamed:@"no_message"];
        self.CenterImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgView addSubview:self.CenterImageView];
        
        
        self.ContentLabel  = [UILabel labelWithFontsize:15.0f  TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentCenter];
        self.ContentLabel.text = @"点击屏幕 重新加载";
        [self.bgView addSubview:self.ContentLabel];
        
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)tap
{
        if (self.ActionBlock) {
             self.ActionBlock();
        }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat bgViewW = XScreenWidth;
    CGFloat bgViewH = 200;
    CGFloat bgViewX = 0;
    CGFloat bgViewY = 0 == self.bgViewY  ? 0.5*(XScreenHeight - bgViewH): self.bgViewY;
    self.bgView.frame = CGRectMake(bgViewX,bgViewY,bgViewW,bgViewH);
    
    CGFloat centerW = 150;
    CGFloat centerH = 150;
    CGFloat centerX = 0.5*(XScreenWidth - centerW);
    CGFloat centerY = 0;
    self.CenterImageView.frame = CGRectMake(centerX,centerY,centerW,centerH);
    
    
    CGFloat conentX = 0;
    CGFloat conentY = CGRectGetMaxY(self.CenterImageView.frame);
    CGFloat conentW = XScreenWidth;
    CGFloat conentH = 20;
    self.ContentLabel.frame = CGRectMake(conentX,conentY,conentW,conentH);
  

}


 @end
