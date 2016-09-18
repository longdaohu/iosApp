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
@property (strong, nonatomic) UILabel *TitleLab;
@property (strong, nonatomic) UIImageView  *arrowView;
@property(nonatomic,copy)NSString *title;
@end

@implementation HomeSectionHeaderView
+(instancetype)sectionHeaderViewWithTitle:(NSString *)title{

    HomeSectionHeaderView *header =  [[HomeSectionHeaderView alloc] init];
    
    header.title = title;
    
    return  header;

}

+(instancetype)view{

    return [[HomeSectionHeaderView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = BACKGROUDCOLOR;
        self.panding =[[UILabel alloc] init];
        [self addSubview:self.panding];
        self.panding.backgroundColor = XCOLOR_LIGHTBLUE;
        self.panding.layer.cornerRadius = 2.5;
        self.panding.layer.masksToBounds = YES;
        
        
        self.TitleLab =[[UILabel alloc] init];
        [self addSubview:self.TitleLab];
        self.TitleLab.font = [UIFont systemFontOfSize:15];
        self.TitleLab.textColor = XCOLOR_DARKGRAY;
        
        
        UIButton *moreBtn =[[UIButton alloc] init];
        self.moreBtn      = moreBtn;
        [moreBtn setTitle:GDLocalizedString(@"Discover_more") forState:UIControlStateNormal];
        [moreBtn setTitleColor:XCOLOR_DARKGRAY forState:UIControlStateNormal];
         moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
         moreBtn.hidden = YES;
        
        UIImageView *arrowView = [[UIImageView alloc] init];
         self.arrowView = arrowView;
        [self addSubview:arrowView];
        arrowView.image = [UIImage imageNamed:@"common_icon_arrow"];
        arrowView.hidden = YES;

        
    }
    return self;
}


-(void)setTitle:(NSString *)title{

    _title = title;
    
    self.TitleLab.text = title;
    
}
- (void)moreButtonHidenNo{
 
    self.moreBtn.hidden = NO;
    self.arrowView.hidden = NO;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat pandingW = 5;
    CGFloat pandingH = 15;
    CGFloat pandingX = ITEM_MARGIN;
    CGFloat pandingY = 0.7 * (contentSize.height - pandingH);
    self.panding.frame = CGRectMake(pandingX,pandingY, pandingW, pandingH);
    
    CGFloat titlex = CGRectGetMaxX(self.panding.frame) + ITEM_MARGIN;
    CGFloat titlew = self.bounds.size.width - titlex;
    CGFloat titleh = pandingH;
    CGFloat titley = pandingY;
    self.TitleLab.frame = CGRectMake(titlex, titley, titlew, titleh);
    
    CGFloat morew = 100;
    CGFloat morex = XScreenWidth - morew;
    CGFloat moreh = pandingH;
    CGFloat morey = pandingY;
    self.moreBtn.frame = CGRectMake(morex, morey, morew, moreh);
    
    CGFloat arrowW = 20;
    CGFloat arrowX = contentSize.width - arrowW - ITEM_MARGIN;
    CGFloat arrowH = pandingH;
    CGFloat arrowY = pandingY;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
}

-(void)moreClick
{
    if (self.actionBlock) {
        
        self.actionBlock();
    }
}

@end
