//
//  XliuxueHeaderView.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "WYLXHeaderView.h"

@interface WYLXHeaderView ()
//图片
@property(nonatomic,strong)UIImageView *iconView;
//标题
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UITextView *titleView;
@end

@implementation WYLXHeaderView

+ (instancetype)headViewWithFrame:(CGRect)frame
{
   
    WYLXHeaderView *header = [[WYLXHeaderView  alloc] initWithFrame:frame];
    
    return header;
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
        
        
        UITextView *titleView =[[UITextView alloc] init];
        titleView.scrollEnabled = NO;
        titleView.editable = NO;
        titleView.textColor =XCOLOR_RED;
        titleView.font = XFONT(XPERCENT * 13);
        titleView.textAlignment = NSTextAlignmentLeft;
        titleView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        titleView.dataDetectorTypes = UIDataDetectorTypeAll;
        titleView.backgroundColor = XCOLOR_BG;
        [self addSubview:titleView];
        self.titleView = titleView;
        
    }
    return self;
}


-(void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLab.text = title;
    
    
    CGSize contentSize = self.bounds.size;
    
    
    CGFloat iconx = 0;
    CGFloat icony = 0;
    CGFloat iconw = contentSize.width;
    CGFloat iconh = 130 + (iconw - 320) * 0.2;
    self.iconView.frame = CGRectMake(iconx,icony,iconw,iconh);

    
    CGFloat titlex = ITEM_MARGIN;
    CGFloat titley = CGRectGetMaxY(self.iconView.frame) + ITEM_MARGIN;
    CGFloat titlew = contentSize.width - 2 * titlex;
    CGFloat titleHeight = [title  KD_sizeWithAttributeFont:XFONT(XPERCENT * 13) maxWidth:titlew].height;
    self.titleView.text = title;
    self.titleView.frame = CGRectMake(titlex, titley, titlew, titleHeight);
    
    
    self.height = CGRectGetMaxY(self.titleView.frame) + ITEM_MARGIN;
    
 }






@end
