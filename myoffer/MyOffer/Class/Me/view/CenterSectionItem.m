//
//  CenterSectionItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CenterSectionItem.h"
@interface CenterSectionItem ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *countLab;
@property(nonatomic,strong)UIButton *touchBtn;
@end
@implementation CenterSectionItem

+(instancetype)viewWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle
{
   
    CenterSectionItem *item =[[CenterSectionItem alloc] init];
    
    item.iconView.image =[UIImage imageNamed:icon];
    
    item.titleLab.text = title;
    
    item.countLab.text = subtitle;
    
    return item;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *touchBtn = [[UIButton alloc] init];
        self.touchBtn      = touchBtn;
        [touchBtn setBackgroundImage:[UIImage KD_imageWithColor:[UIColor colorWithWhite:1 alpha:0.9]] forState:UIControlStateHighlighted];
        [touchBtn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:touchBtn];

        UIImageView *iconView =[[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView = iconView;
        [self addSubview:iconView];
        

        UILabel *titleLab = [UILabel labelWithFontsize:KDUtilSize(15) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentCenter];
        self.titleLab     = titleLab;
        [self addSubview:titleLab];
        

        UILabel *countLab = [UILabel labelWithFontsize:KDUtilSize(12) TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentCenter];
        self.countLab     = countLab;
        [self addSubview:countLab];
        
        

        
    }
    return self;
}


-(void)tap:(UIButton *)sender
{
    if (self.actionBlack) {
        
        self.actionBlack(sender);
        
    }
}

-(void)setCount:(NSString *)count
{
    _count = count;
    
    self.countLab.text = [NSString stringWithFormat:@"%@",count];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat countHeight = self.bounds.size.height;
    CGFloat countWidth  = self.bounds.size.width;
    
    CGFloat iconX = 0;
    CGFloat iconY = countHeight * 0.15;
    CGFloat iconW = countWidth;
    CGFloat iconH = countHeight * 0.4;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat titleX = 0;
    CGFloat titleY = CGRectGetMaxY(self.iconView.frame);
    CGFloat titleW = countWidth;
    CGFloat titleH = countHeight * 0.2;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);

    CGFloat countX = 0;
    CGFloat countY = CGRectGetMaxY(self.titleLab.frame);
    CGFloat countW = countWidth;
    CGFloat countH = countHeight  * 0.2;
    self.countLab.frame = CGRectMake(countX, countY, countW, countH);
    
    self.touchBtn.frame = self.bounds;


}

@end
