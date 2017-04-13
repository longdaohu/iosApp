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

- (void)setUni_Frame:(UniversityNewFrame *)Uni_Frame{

    _Uni_Frame = Uni_Frame;
    
    self.iconView.frame = Uni_Frame.data_item_iconFrame;
    self.titleLab.frame = Uni_Frame.data_item_titleFrame;
    self.subtitleLab.frame = Uni_Frame.data_item_subFrame;
    self.count_Lab.frame = Uni_Frame.data_item_countFrame;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    self.top_line.frame = CGRectMake(0, 0, contentSize.width, 1);
    self.bottom_line.frame = CGRectMake(0, contentSize.height, contentSize.width, 1);

}







@end
