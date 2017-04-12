//
//  UniversityDetailItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityDetailItem.h"

@interface UniversityDetailItem ()
//图片
@property(nonatomic,strong)UIImageView *iconView;
//名称
@property(nonatomic,strong)UILabel     *titleLab;
//详情
@property(nonatomic,strong)UILabel     *subtitleLab;
//数字
@property(nonatomic,strong)UILabel     *count_Lab;

@property(nonatomic,strong)CALayer *bottom_line;
@property(nonatomic,strong)CALayer *top_line;

@property(nonatomic,copy)NSString *title;

@end

@implementation UniversityDetailItem

+ (instancetype)ItemInitWithImage:(NSString *)imageName title:(NSString *)title  count:(NSString *)count{
    
    UniversityDetailItem *item = [[UniversityDetailItem alloc] init];
    
    item.iconView.image        = [UIImage imageNamed:imageName];

    item.title = title;
 
    item.count_Lab.text = count;
    
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeCenter;
        [self addSubview:iconView];
        self.iconView = iconView;
        
        
        UILabel *tilteLab = [UILabel labelWithFontsize:XFONT_SIZE(14) TextColor:XCOLOR_DESC TextAlignment:NSTextAlignmentCenter];
        [self addSubview:tilteLab];
        tilteLab.numberOfLines = 2;
        self.titleLab = tilteLab;
        
        UILabel *subLab  = [UILabel labelWithFontsize:XFONT_SIZE(12) TextColor:XCOLOR_DESC TextAlignment:NSTextAlignmentCenter];
        [self addSubview:subLab];
        self.subtitleLab = subLab;

        UILabel *count_Lab  = [UILabel labelWithFontsize:XFONT_SIZE(14) TextColor:XCOLOR_TITLE TextAlignment:NSTextAlignmentCenter];
        [self addSubview:count_Lab];
        self.count_Lab = count_Lab;
        
        
        CALayer *top_line = [CALayer layer];
        top_line.backgroundColor = XCOLOR_line.CGColor;
        [self.layer addSublayer:top_line];
        self.top_line = top_line;
        
        
        CALayer *bottom_line = [CALayer layer];
        [self.layer addSublayer:bottom_line];
        self.bottom_line = bottom_line;
        bottom_line.backgroundColor = XCOLOR_line.CGColor;

    }
    return self;
}


- (void)setTitle:(NSString *)title{

    _title = title;

    self.titleLab.text = title;
    
    NSString *fee_key = @"+";
    
    if ([self.title containsString:fee_key]) {
        
        NSArray *items = [self.title componentsSeparatedByString:fee_key];
        self.titleLab.text = items.firstObject;
        self.subtitleLab.text = items.lastObject;
        
    }
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    self.top_line.frame = CGRectMake(0, 0, contentSize.width, 1);
    self.bottom_line.frame = CGRectMake(0, contentSize.height, contentSize.width, 1);
    
    
    CGFloat icon_X = 0;
    CGFloat icon_Y = 0;
    CGFloat icon_W = contentSize.width;
    CGFloat icon_H = 24;

    CGFloat title_X = 0;
    CGFloat title_Y = icon_Y + icon_H + 3;
    CGFloat title_W = contentSize.width;
    CGFloat title_H = self.titleLab.font.lineHeight;

    CGFloat sub_X = title_X;
    CGFloat sub_W =  title_W;
    CGFloat sub_H = self.subtitleLab.font.lineHeight;
    CGFloat sub_Y =  title_Y + title_H;
    
    CGFloat count_X = 0;
    CGFloat count_W = contentSize.width;
    CGFloat count_H = self.count_Lab.font.lineHeight;
    CGFloat count_Y =  sub_H + sub_Y + 3;
    
    
    CGFloat margin = (contentSize.height - count_H  - count_Y) * 0.5;
    
    icon_Y += margin;
    self.iconView.frame = CGRectMake(icon_X, icon_Y, icon_W, icon_H);

    title_Y += margin;
    self.titleLab.frame = CGRectMake(title_X, title_Y, title_W, title_H);

    sub_Y   += margin;
    self.subtitleLab.frame = CGRectMake(sub_X, sub_Y, sub_W, sub_H);
   
    count_Y += margin;
    self.count_Lab.frame = CGRectMake(count_X, count_Y, count_W, count_H);
    
}







@end
