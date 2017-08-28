//
//  GongLueHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "GongLueHeaderView.h"

@interface GongLueHeaderView ()
//顶部View
//@property(nonatomic,strong)UIView *topView;
//底部View
@property(nonatomic,strong)UIView *bottomView;
//小MO头像
@property(nonatomic,strong)UIImageView *moLogo;
//标题
@property(nonatomic,strong)UILabel *titleLab;
//描述
@property(nonatomic,strong)UILabel *subTitleLab;
//titleLab原始Frame
@property(nonatomic,assign)CGRect headerTitleLabFrame;

@property(nonatomic,strong)UILabel *headerTitleLab;
//小MO头像及其他控件背景
@property(nonatomic,strong)UIView *centerView;

@property(nonatomic,assign)CGFloat titlePadding;


@end

@implementation GongLueHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        //底部
        self.bottomView =[[UIView alloc] init];
        self.bottomView.backgroundColor = XCOLOR_BG;
        [self addSubview:self.bottomView];
        
        
        //中间View
        self.centerView =[[UIView alloc] init];
        self.centerView.layer.cornerRadius = CORNER_RADIUS;
        self.centerView.backgroundColor = XCOLOR_BG;
        [self addSubview:self.centerView];
        self.centerView.layer.shadowColor = XCOLOR_BLACK.CGColor;
        self.centerView.layer.shadowOffset = CGSizeMake(0, 2);
        self.centerView.layer.shadowOpacity = 0.2;
        
        
        //logo小图标
        self.moLogo =[[UIImageView alloc] init];
        self.moLogo.image = [UIImage imageNamed:@"default_avatar"];
        self.moLogo.clipsToBounds = YES;
        [self.centerView addSubview:self.moLogo];
        
        //小标题
        self.titleLab = [UILabel labelWithFontsize:KDUtilSize(18)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.centerView addSubview:self.titleLab];
        self.titleLab.text = @"小MO话你知";
        
        //描述信息
        self.subTitleLab = [UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        self.subTitleLab.numberOfLines = 0;
        [self.centerView addSubview:self.subTitleLab];
        
        //标题
        self.headerTitleLab = [UILabel labelWithFontsize:KDUtilSize(20)  TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
        [self insertSubview:self.headerTitleLab belowSubview:self.centerView];
        
        
  
    }
    return self;
}


- (void)setGonglue:(GonglueItem *)gonglue{

    _gonglue = gonglue;
    
    self.headerTitleLab.text = gonglue.title;
    [self.headerTitleLab sizeToFit];
    
    self.subTitleLab.text =  gonglue.tip[@"content"];
    
    
    CGSize contentSize = self.bounds.size;
 
    CGFloat centerView_X = ITEM_MARGIN;
    CGFloat centerView_W = contentSize.width - centerView_X * 2;
    
    CGFloat logo_X = ITEM_MARGIN;
    CGFloat logo_Y = ITEM_MARGIN;
    CGFloat logo_W = 30 + KDUtilSize(0) * 5;
    CGFloat logo_H = logo_W;
    self.moLogo.frame = CGRectMake(logo_X, logo_Y, logo_W, logo_H);
    
    CGFloat centerView_Y =   self.top_View_Height - CGRectGetMaxY(self.moLogo.frame);
    
    
    CGFloat title_X = CGRectGetMaxX(self.moLogo.frame) + ITEM_MARGIN;
    CGFloat title_Y = logo_Y;
    CGFloat title_W = centerView_W - title_X;
    CGFloat title_H = logo_H;
    self.titleLab.frame = CGRectMake(title_X, title_Y, title_W, title_H);
    
    CGFloat sub_X   = ITEM_MARGIN;
    CGFloat sub_W   = centerView_W - sub_X * 2;
    CGSize subSize = [self.subTitleLab.text  KD_sizeWithAttributeFont:XFONT(KDUtilSize(13)) maxWidth:sub_W];
    CGFloat sub_H   = subSize.height;
    CGFloat sub_Y   = CGRectGetMaxY(self.moLogo.frame) + ITEM_MARGIN;
    self.subTitleLab.frame =CGRectMake(sub_X, sub_Y, sub_W, sub_H);
    
    
    CGFloat centerView_H  = CGRectGetMaxY(self.subTitleLab.frame) + ITEM_MARGIN;
    self.centerView.frame = CGRectMake(centerView_X, centerView_Y, centerView_W, centerView_H);
    
    
    self.height = CGRectGetMaxY(self.centerView.frame) + 2 * ITEM_MARGIN;
    
    
    
     CGFloat headerTitleY = CGRectGetMinY(self.centerView.frame) - self.headerTitleLab.mj_h - 20;
     self.headerTitleLab.mj_y =  headerTitleY;
     self.headerTitleLab.mj_w =  contentSize.width;
     self.headerTitleLabFrame = self.headerTitleLab.frame;
    
    
    CGFloat bgX =   0;
    CGFloat bgY =   self.top_View_Height;
    CGFloat bgW =   contentSize.width;
    CGFloat bgH =   self.height  - bgY;
    self.bottomView.frame = CGRectMake(bgX, bgY, bgW, bgH);

    self.titlePadding = self.centerView.mj_y - CGRectGetMaxY(self.headerTitleLabFrame);
    
  
}



//根据contentOffsetY调整效果
- (void)scrollViewDidScrollWithcontentOffsetY:(CGFloat)contentOffsetY{

    
     self.nav_Alpha = (contentOffsetY - self.titlePadding) / self.headerTitleLab.mj_h;
    
 
    if (contentOffsetY > 0) {
        
        CGRect newRect = self.headerTitleLabFrame;
        newRect.origin.y +=  contentOffsetY;
        self.headerTitleLab.frame = newRect;
        
        
        return;
    }
    
    self.headerTitleLab.frame = self.headerTitleLabFrame;
   
}





@end
