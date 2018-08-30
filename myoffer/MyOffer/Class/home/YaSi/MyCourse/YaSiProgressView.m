//
//  YaSiProgressView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YaSiProgressView.h"

@interface YaSiProgressView ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,assign)CAShapeLayer *progressLayer;

@end

@implementation YaSiProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_BG;
        
        UILabel *titleLab = [UILabel new];
        titleLab.font = XFONT(10);
        self.titleLab = titleLab;
        titleLab.textColor = XCOLOR_LIGHTBLUE;
        titleLab.backgroundColor = XCOLOR_WHITE;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"50%";
        [self addSubview:titleLab];
        
        
        CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
        progressLayer.backgroundColor = [UIColor clearColor].CGColor;
        progressLayer.fillColor = XCOLOR_CLEAR.CGColor;
        progressLayer.strokeColor = XCOLOR_LIGHTBLUE.CGColor;
        progressLayer.lineWidth = 4;
        progressLayer.lineCap = @"round";
        progressLayer.strokeStart  = 0;
        progressLayer.strokeEnd =  0.6;
        self.progressLayer = progressLayer;
        [self.layer addSublayer:progressLayer];

    }
    return self;
}


- (void)setProgress:(CGFloat)progress{
    _progress = progress;
 
    NSInteger count = (NSInteger)progress * 100;
    self.titleLab.text = [NSString stringWithFormat:@"%ld%%",count];
    self.progressLayer.strokeEnd =  progress;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize content_size = self.bounds.size;
    self.layer.cornerRadius = content_size.height * 0.5;
    
    CGFloat margin = 4;
    CGFloat title_x  = margin;
    CGFloat title_y  = margin;
    CGFloat title_w  = content_size.width - title_x * 2;
    CGFloat title_h  = content_size.height - title_y * 2;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
    self.titleLab.layer.cornerRadius = title_h * 0.5;
    self.titleLab.layer.masksToBounds = YES;
    
    CGFloat pth_x  =  title_x * 0.5;
    CGFloat pth_y  =  title_y * 0.5;
    CGFloat pth_w  =  content_size.width - pth_x * 2;
    CGFloat pth_h  =  content_size.height - pth_y * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(pth_x, pth_y, pth_w, pth_h) cornerRadius:title_h * 0.5];
    self.progressLayer.path = path.CGPath;
    
}

@end
