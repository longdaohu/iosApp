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
    
    item.countLab.text = subtitle;

    
    return item;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIButton *touchBtn = [[UIButton alloc] init];
        self.touchBtn      = touchBtn;
        [touchBtn setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_line] forState:UIControlStateHighlighted];
        [touchBtn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:touchBtn];

        UIImageView *iconView =[[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView = iconView;
        [self addSubview:iconView];
        

        UILabel *titleLab = [UILabel labelWithFontsize:KDUtilSize(XFONT_SIZE(18)) TextColor:XCOLOR_TITLE TextAlignment:NSTextAlignmentCenter];
        self.titleLab     = titleLab;
        [self addSubview:titleLab];
        

        UILabel *countLab = [UILabel labelWithFontsize:KDUtilSize(XFONT_SIZE(14)) TextColor:XCOLOR_SUBTITLE TextAlignment:NSTextAlignmentCenter];
        self.countLab     = countLab;
        [self addSubview:countLab];
        
        

        
    }
    return self;
}


-(void)tap:(UIButton *)sender{
    
    if (self.actionBlack) self.actionBlack(sender);
        
}

-(void)setCount:(NSString *)count
{
    _count = count;
    
    self.countLab.text = [NSString stringWithFormat:@"%@",count];
    
}

- (void)setHeader_Frame:(MeCenterHeaderViewFrame *)header_Frame{

    _header_Frame = header_Frame;
    
    self.iconView.frame = header_Frame.icon_frame;
    self.titleLab.frame = header_Frame.title_frame;
    self.countLab.frame = header_Frame.count_frame;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];

    self.touchBtn.frame = self.bounds;
 
}

@end
