//
//  HomeSectionHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "HomeSectionHeaderView.h"
@interface HomeSectionHeaderView ()
@property (strong, nonatomic) UILabel *panding;
@end

@implementation HomeSectionHeaderView

+(instancetype)view{

    return [[HomeSectionHeaderView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.panding =[[UILabel alloc] init];
        [self addSubview:self.panding];
        self.panding.backgroundColor = XCOLOR_LIGHTBLUE;
        self.panding.layer.cornerRadius = 2.5;
        self.panding.layer.masksToBounds = YES;
        
        
        self.TitleLab =[[UILabel alloc] init];
        [self addSubview:self.TitleLab];
        self.TitleLab.font = [UIFont systemFontOfSize:15];
        self.TitleLab.textColor = XCOLOR_DARKGRAY;
        
        self.moreBtn =[[XUButton alloc] init];
        [self.moreBtn setTitle:GDLocalizedString(@"Discover_more") forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"common_icon_arrow"] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:XCOLOR_DARKGRAY forState:UIControlStateNormal];
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
         [self.moreBtn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreBtn];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat pw = 5;
    CGFloat ph = 15;
    CGFloat py = self.bounds.size.height - 5 - ph;
    CGFloat px = ITEM_MARGIN;
    self.panding.frame = CGRectMake(px, py, pw, ph);
    
    CGFloat titlex = CGRectGetMaxX(self.panding.frame) + ITEM_MARGIN;
    CGFloat titlew = self.bounds.size.width - titlex;
    CGFloat titleh = ph;
    CGFloat titley = py;
    self.TitleLab.frame = CGRectMake(titlex, titley, titlew, titleh);
    
    CGFloat morew = 100;
    CGFloat morex = XScreenWidth - morew;
    CGFloat moreh = self.bounds.size.height;
    CGFloat morey = titley - 0.5 * (moreh - titleh);
    self.moreBtn.frame = CGRectMake(morex, morey, morew, moreh);
    
}

-(void)tap
{
    if (self.actionBlock) {
        
        self.actionBlock();
    }
}

@end
