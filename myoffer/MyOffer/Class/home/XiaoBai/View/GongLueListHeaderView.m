//
//  GongLueListHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "GongLueListHeaderView.h"

@interface GongLueListHeaderView ()
@property(nonatomic,strong)UIView *bgView;
//小MO头像
@property(nonatomic,strong)UIImageView *moLogo;
//标题
@property(nonatomic,strong)UILabel *titleLab;
//简介Lab
@property(nonatomic,strong)UILabel *subTitleLab;
//titleLab原始Frame
@property(nonatomic,assign)CGRect headerTitleLabFrame;

@end

@implementation GongLueListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];

        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_BG;
        [self addSubview:self.bgView];

        
        self.moBgView =[[UIView alloc] init];
        self.moBgView.layer.cornerRadius = 5;
        self.moBgView.backgroundColor = XCOLOR_BG;
        [self addSubview:self.moBgView];
        self.moBgView.layer.shadowColor = XCOLOR_BLACK.CGColor;
        self.moBgView.layer.shadowOffset = CGSizeMake(0, 2);
        self.moBgView.layer.shadowOpacity = 0.2;
        
        
        self.moLogo =[[UIImageView alloc] init];
        self.moLogo.image = [UIImage imageNamed:@"default_avatar"];
        self.moLogo.clipsToBounds = YES;
        self.moLogo.contentMode = UIViewContentModeScaleAspectFit;
        [self.moBgView addSubview:self.moLogo];
        
        
        self.titleLab = [UILabel labelWithFontsize:KDUtilSize(18)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        [self.moBgView addSubview:self.titleLab];
        self.titleLab.text = @"小MO话你知";
        
        self.subTitleLab = [UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
        self.subTitleLab.numberOfLines = 0;
        [self.moBgView addSubview:self.subTitleLab];
        
        
        self.headerTitleLab = [UILabel labelWithFontsize:KDUtilSize(20)  TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
        [self insertSubview:self.headerTitleLab belowSubview:self.bgView];
        
        
 
    }
    return self;
}

-(void)setGongLueDic:(NSDictionary *)gongLueDic{

    _gongLueDic = gongLueDic;
    
    self.headerTitleLab.text = gongLueDic[@"title"];
    self.subTitleLab.text =  gongLueDic[@"tip"][@"content"];
    
    
    CGFloat logoX = ITEM_MARGIN;
    CGFloat logoY = ITEM_MARGIN;
    CGFloat logoW = 30 + KDUtilSize(0) * 5;
    CGFloat logoH = logoW;
    self.moLogo.frame = CGRectMake(logoX, logoY, logoW, logoH);
    
    
    CGFloat moBgViewX = ITEM_MARGIN;
    CGFloat moBgViewW = XScreenWidth - moBgViewX * 2;
    
    
    CGFloat titleX = CGRectGetMaxX(self.moLogo.frame) + ITEM_MARGIN;
    CGFloat titleY = logoY;
    CGFloat titleW = moBgViewW - titleX;
    CGFloat titleH = logoH;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat subX   = ITEM_MARGIN;
    CGFloat subW   = moBgViewW - subX * 2;
    CGSize subSize = [self.subTitleLab.text  KD_sizeWithAttributeFont:XFONT(KDUtilSize(13)) maxWidth:subW];
    CGFloat subH   = subSize.height;
    CGFloat subY   = CGRectGetMaxY(self.moLogo.frame) + ITEM_MARGIN;
    self.subTitleLab.frame =CGRectMake(subX, subY, subW, subH);
    
    
    CGFloat moBgViewH =   CGRectGetMaxY(self.subTitleLab.frame) + ITEM_MARGIN;
    CGFloat moBgViewY =   self.height - CGRectGetMaxY(self.moLogo.frame);
    
    self.moBgView.frame = CGRectMake(moBgViewX, moBgViewY, moBgViewW, moBgViewH);
    
    self.height += (moBgViewH - CGRectGetMaxY(self.moLogo.frame)  + 20);
    CGSize  contentSize = self.bounds.size;
    
    CGFloat headerTitleX = 0;
    CGFloat headerTitleW = XScreenWidth;
    CGFloat headerTitleH = 23;
    CGFloat headerTitleY = CGRectGetMinY(self.moBgView.frame) - headerTitleH - KDUtilSize(15);
    self.headerTitleLab.frame = CGRectMake(headerTitleX, headerTitleY, headerTitleW, headerTitleH);
    self.headerTitleLabFrame = self.headerTitleLab.frame;
    
    CGFloat bgX =   0;
    CGFloat bgY =   moBgViewY + CGRectGetMaxY(self.moLogo.frame);
    CGFloat bgW =   XScreenWidth;
    CGFloat bgH =   contentSize.height  - bgY;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
     
}



-(void)setContentOffsetY:(CGFloat)contentOffsetY
{
    _contentOffsetY = contentOffsetY;
    
 
    
    if (contentOffsetY <= 0) {
 
            self.headerTitleLab.frame = self.headerTitleLabFrame;
        
    }else{
    
        CGSize  contentSize = self.bounds.size;

        if (contentSize.height - CGRectGetMaxY(self.headerTitleLab.frame) >= 0) {
            
            CGRect NewRect = self.headerTitleLabFrame;
            
            NewRect.origin.y  =  self.headerTitleLabFrame.origin.y + contentOffsetY;
            
            self.headerTitleLab.frame = NewRect;
            
        }
        
    }
    
}






@end
