//
//  XliuxueHeaderView.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "XliuxueHeaderView.h"

@interface XliuxueHeaderView ()
//图片
@property(nonatomic,strong)UIImageView *iconView;
//标题
@property(nonatomic,strong)UILabel *titleLab;
@end

@implementation XliuxueHeaderView

+(instancetype)headView
{
   
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.iconView =[[UIImageView alloc] init];
        self.iconView.clipsToBounds = YES;
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconView.image = [UIImage imageNamed:@"woYaoLiuXue.jpg"];
        [self addSubview:self.iconView];
        
        self.titleLab =[UILabel labelWithFontsize:FONTSIZE(15)  TextColor:XCOLOR_RED TextAlignment:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 0;
        self.titleLab.lineBreakMode = NSLineBreakByCharWrapping;
         [self addSubview:self.titleLab];
        
    }
    return self;
}


-(void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLab.text = title;
    
    CGFloat iconx = 0;
    CGFloat icony = 0;
    CGFloat iconw = XScreenWidth;
    CGFloat iconh = 130 + (iconw - 320) * 0.2;
    self.iconView.frame = CGRectMake(iconx,icony,iconw,iconh);

    
    CGFloat titlex = ITEM_MARGIN;
    CGFloat titley = CGRectGetMaxY(self.iconView.frame) + ITEM_MARGIN ;
    CGFloat titlew = XScreenWidth - 2*titlex;
    CGFloat titleHeight = [self stringHightWithTitle:title andFontSize:FONTSIZE(15)];
    self.titleLab.frame = CGRectMake(titlex, titley, titlew, titleHeight);
    
    self.Height = CGRectGetMaxY(self.titleLab.frame) + 20;

}



-(CGFloat )stringHightWithTitle:(NSString *)string andFontSize:(CGFloat)size
{
    CGFloat width = XScreenWidth - 20;
    CGRect frame = [string boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil];
    return frame.size.height;
}




@end
