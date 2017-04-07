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
    
    item.iconView.image = XImage(icon);
    
    item.titleLab.text = title;
    
    [item.titleLab sizeToFit];
 
    item.countLab.text = subtitle;
    
    [item.countLab sizeToFit];

    
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
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat icon_X = 0;
    CGFloat icon_Y = 0;
    CGFloat icon_W = contentSize.width;
    CGFloat icon_H = self.iconView.image.size.height;
    
    CGFloat titleX = 0;
    CGFloat titleY = icon_H + 10;
    CGFloat titleW = contentSize.width;
    CGFloat titleH = self.titleLab.bounds.size.height;

    CGFloat countX = 0;
    CGFloat countY = titleY + titleH;
    CGFloat countW = contentSize.width;
    CGFloat countH = self.countLab.bounds.size.height;

    
    CGFloat margin = contentSize.height - (countY + countH);
    icon_Y = margin * 0.5;
    self.iconView.frame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);
    
    titleY  += margin * 0.5;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    countY += margin * 0.5;
    self.countLab.frame = CGRectMake(countX, countY, countW, countH);

    
    self.touchBtn.frame = self.bounds;


}

@end
