//
//  HeadItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HeadItem.h"
@interface HeadItem ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;

@end

@implementation HeadItem

+ (instancetype)itemWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    HeadItem *item = [[HeadItem alloc] init];
    item.title     = title;
    item.icon      = imageName;
    
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        [self makeUI];
        
    }
    return self;
}


- (void)makeUI{

    UIImageView *iconView  =[[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:iconView];
    self.iconView = iconView;
    
    self.titleLab  = [UILabel labelWithFontsize:10 TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemOnclick)];
    [self addGestureRecognizer:tap];
    
}

- (void)setTitle:(NSString *)title
{
    _title             = title;
    
    self.titleLab.text = title;
}

-(void)setIcon:(NSString *)icon
{
    _icon = icon;
    
    self.iconView.image = [UIImage imageNamed:icon];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGSize  contentSize = self.bounds.size;

    CGFloat iconh = contentSize.height * 0.7;
    CGFloat iconw = iconh;
    CGFloat icony = 0;
    CGFloat iconx = 0.5 * (contentSize.width - iconw);
    self.iconView.frame = CGRectMake(iconx, icony, iconw, iconh);
    
    CGFloat titlex = 0;
    CGFloat titley = CGRectGetMaxY(self.iconView.frame) - 3;
    CGFloat titlew = contentSize.width;
    CGFloat titleh = contentSize.height -CGRectGetMaxY(self.iconView.frame);
    self.titleLab.frame = CGRectMake(titlex, titley, titlew, titleh);
    self.titleLab.font  = [UIFont systemFontOfSize:0.5 * titleh];
    
}

-(void)itemOnclick
{
    
    if (self.actionBlock) {
        
        self.actionBlock(self.tag);
        
    }
}

@end
