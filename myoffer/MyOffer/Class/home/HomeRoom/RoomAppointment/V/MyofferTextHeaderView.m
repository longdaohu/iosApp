//
//  MyofferTextHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/10.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyofferTextHeaderView.h"

@interface MyofferTextHeaderView ()
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation MyofferTextHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title_font_size = 16;
        
        UILabel *titleLab = [UILabel label];
        titleLab.font = XFONT(self.title_font_size);
        titleLab.textColor = XCOLOR_LIGHTBLUE;
        titleLab.numberOfLines = 0;
        titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab = titleLab;
        [self addSubview:titleLab];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    self.titleLab.text = title;
}

- (void)setTitle_color:(UIColor *)title_color{
    
    _title_color = title_color;
    self.titleLab.textColor = title_color;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize content_size = self.bounds.size;
    CGFloat left = 20;
    CGFloat top = 20;
    
    CGFloat title_x = left;
    CGFloat title_y = top;
    CGFloat title_w = content_size.width - title_x * 2;
    CGFloat title_h = 0;
    CGSize  title_size = [self.titleLab.text sizeWithfontSize:self.title_font_size maxWidth:title_w];
    title_h = title_size.height;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
    self.mj_h =  CGRectGetMaxY(self.titleLab.frame) +top;
 
    UIView *sp = self.superview;
    if ([sp isKindOfClass:[UITableView class]]) {
        UITableView *tb = (UITableView *)sp;
        tb.tableHeaderView = self;
    }
 
}

@end
