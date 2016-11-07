//
//  UpgradeTipsView.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UpgradeFooterView.h"

@interface UpgradeFooterView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLab;          //1、提示信息
@property(nonatomic,strong)UILabel *moreLab;         //2、了解详情
@property(nonatomic,strong)UIImageView *arrowView;   //3、箭头
@end

;

@implementation UpgradeFooterView
+ (instancetype)footViewWithContent:(NSString *)content
{
    UpgradeFooterView *footer = [[UpgradeFooterView alloc] initWithFrame:CGRectMake(0, 10, XScreenWidth,0)];
    
    footer.tipStr = content;
    
    return  footer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIView *bgView = [[UIView alloc] init];
        [self addSubview:bgView];
        self.bgView = bgView;
        self.bgView.backgroundColor = XCOLOR(232, 233, 232);
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.borderColor  = XCOLOR(204, 204, 204).CGColor;
        self.bgView.layer.borderWidth = 0.5;
        
        //1、提示信息
        self.titleLab = [UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR(137, 137, 137) TextAlignment:NSTextAlignmentLeft];
        [ self.bgView addSubview:self.titleLab];
        self.titleLab.numberOfLines = 0;
 
        
        //2、了解详情
        self.moreLab =[UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_RED TextAlignment:NSTextAlignmentRight];
        self.moreLab.text = @"了解详情";
        [ self.bgView addSubview:self.moreLab];
        
        //3、箭头
        self.arrowView =[[UIImageView alloc] init];
        self.arrowView.image = [UIImage imageNamed:@"TJ_arrow"];
        self.arrowView.contentMode = UIViewContentModeScaleAspectFit;
        [ self.bgView addSubview:self.arrowView];
        
        //点击手势，用于页面跳转
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
        [ self.bgView addGestureRecognizer:tap];
        
  

    }
    return self;
}

-(void)setTipStr:(NSString *)tipStr{

    _tipStr = tipStr;
 
    self.titleLab.text = tipStr;
    
     
    CGSize contentSize = self.bounds.size;
    CGFloat padding  = 10;
    
    CGFloat bgX = 15;
    CGFloat bgY = 0;
    CGFloat bgW = contentSize.width - 2 * bgX;
    
    CGFloat tipX =  padding;
    CGFloat tipW = bgW - 2 * tipX;
    CGFloat tipY = padding;
    CGSize tipSize = [self getContentBoundWithTitle:self.tipStr andFontSize:KDUtilSize(13) andMaxWidth:tipW];
    CGFloat tipH = tipSize.height;
    self.titleLab.frame = CGRectMake(tipX, tipY, tipW, tipH);
    
    
    CGFloat bgH =  CGRectGetMaxY(self.titleLab.frame) + 2 * padding;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    
     
    CGFloat arrowH =  15;
    CGFloat arrowW =  15;
    CGFloat arrowY =  bgH - padding - arrowH;
    CGFloat arrowX =  CGRectGetMaxX(self.titleLab.frame) - arrowW;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
    CGFloat moreW =  arrowX;
    CGFloat moreX =  0;
    CGFloat moreH =  arrowH;
    CGFloat moreY =  arrowY;
    self.moreLab.frame = CGRectMake(moreX, moreY, moreW, moreH);
 
}


-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}


-(void)layoutSubviews{
   
    [super layoutSubviews];
   
}


-(void)onClick{

    if (self.actionBlock) {
        
        self.actionBlock();
    }
}


@end
