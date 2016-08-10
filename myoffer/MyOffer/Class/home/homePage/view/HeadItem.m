//
//  HeadItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HeadItem.h"
@interface HeadItem ()
@property(nonatomic,strong)UIButton *IconBtn;
@property(nonatomic,strong)UILabel *titleLab;
@end

@implementation HeadItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.IconBtn =[[UIButton alloc] init];
          [self.IconBtn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.IconBtn];
        
        self.titleLab               = [[UILabel alloc] init];
        self.titleLab.textColor     = XCOLOR_WHITE;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title             = title;
    self.titleLab.text = title;
    
}

-(void)setIcon:(NSString *)icon
{
    _icon = icon;
    
   [self.IconBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
}

-(void)setIconTag:(NSInteger)iconTag
{
    _iconTag         = iconTag;
    self.IconBtn.tag = iconTag;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iw = self.bounds.size.width - KDUtilSize(0) * 5;
    CGFloat iy = KDUtilSize(0) * 7;
    CGFloat ix = 0.5 * (self.bounds.size.width - iw);
    CGFloat ih = iw;
    self.IconBtn.frame = CGRectMake(ix, iy, iw, ih);
    
    CGFloat tx = 0;
    CGFloat ty = CGRectGetMaxY(self.IconBtn.frame) - KDUtilSize(0) * 3;
    CGFloat tw = self.bounds.size.width;
    CGFloat th = self.bounds.size.height - ih - KDUtilSize(0) * 5;
    self.titleLab.frame = CGRectMake(tx, ty, tw, th);
    self.titleLab.font  = [UIFont systemFontOfSize:0.30 * th];
    
}

-(void)tap:(UIButton *)sender
{
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

@end
