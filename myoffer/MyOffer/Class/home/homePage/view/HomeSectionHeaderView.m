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
//更多按钮
@property (strong, nonatomic) UIButton *moreBtn;
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
        self.backgroundColor = XCOLOR_BG;
        
        self.panding =[[UILabel alloc] init];
        [self addSubview:self.panding];
        self.panding.backgroundColor = XCOLOR_LIGHTBLUE;
        self.panding.layer.cornerRadius = 2.5;
        self.panding.layer.masksToBounds = YES;
        
        
        self.TitleLab =[[UILabel alloc] init];
        [self addSubview:self.TitleLab];
        self.TitleLab.font = [UIFont systemFontOfSize:16];
        self.TitleLab.textColor = XCOLOR_TITLE;
        
        
        UIButton *moreBtn =[[UIButton alloc] init];
        self.moreBtn      = moreBtn;
        [moreBtn setTitle:GDLocalizedString(@"Discover_more") forState:UIControlStateNormal];
        [moreBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
         moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
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


- (void)setTitle:(NSString *)title{

    _title = title;
    
    NSArray *items = [title componentsSeparatedByString:@"+"];
    
    self.TitleLab.text = items.firstObject;
    
    [self.moreBtn setTitle:items.lastObject forState:UIControlStateNormal];
    
}

- (void)setMoreDiscription:(NSString *)moreDiscription{

    _moreDiscription = moreDiscription;
    
    [self.moreBtn setTitle:moreDiscription forState:UIControlStateNormal];

}

- (void)setContentFontSize:(CGFloat)contentFontSize{

    _contentFontSize = contentFontSize;
    
    self.TitleLab.font = [UIFont systemFontOfSize:contentFontSize];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:contentFontSize];
    
}


- (void)moreButtonHidenNo{
 
    self.moreBtn.hidden = NO;
    self.arrowView.hidden = NO;
    
}

- (void)arrowButtonHiden:(BOOL)hiden{

    self.arrowView.hidden = hiden;
    self.moreBtn.hidden = hiden;
    
    if (!hiden) {
        
        [self.moreBtn setTitle:@"  " forState:UIControlStateNormal];

    }

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.title) return;
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat pandingW = 5;
    CGFloat pandingH = 16;
    CGFloat pandingX = ITEM_MARGIN;
    CGFloat pandingY = 0;
    self.panding.frame = CGRectMake(pandingX,pandingY, pandingW, pandingH);
    self.panding.center = CGPointMake(self.panding.center.x, contentSize.height * 0.5);

    CGFloat titlex = CGRectGetMaxX(self.panding.frame) + ITEM_MARGIN;
    CGFloat titlew = contentSize.width - titlex;
    CGFloat titleh = self.contentFontSize ? self.contentFontSize : pandingH;
    CGFloat titley = 0;
    self.TitleLab.frame = CGRectMake(titlex, titley, titlew, titleh);
    self.TitleLab.center = CGPointMake(self.TitleLab.center.x, contentSize.height * 0.5);

    CGFloat morew = 120;
    CGFloat morex = contentSize.width - morew;
    CGFloat moreh = titleh;
    CGFloat morey = 0;
    self.moreBtn.frame = CGRectMake(morex, morey, morew, moreh);
    self.moreBtn.center = CGPointMake(self.moreBtn.center.x, contentSize.height * 0.5);

    CGFloat arrowW = 20;
    CGFloat arrowX = contentSize.width - arrowW - ITEM_MARGIN;
    CGFloat arrowH = titleh;
    CGFloat arrowY = 0;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    self.arrowView.center = CGPointMake(self.arrowView.center.x, contentSize.height * 0.5);
    
}

-(void)moreClick{
    
    if (self.actionBlock) self.actionBlock();
    
}

@end
