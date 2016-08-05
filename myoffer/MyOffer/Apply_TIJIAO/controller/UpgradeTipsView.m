//
//  UpgradeTipsView.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UpgradeTipsView.h"

@interface UpgradeTipsView ()
@property(nonatomic,strong)UILabel *tipLab;          //1、提示信息
@property(nonatomic,strong)UILabel *moreLab;         //2、了解详情
@property(nonatomic,strong)UIImageView *arrowView;   //3、箭头
@end

@implementation UpgradeTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.backgroundColor = XCOLOR(232, 233, 232);
        self.layer.cornerRadius = 5;
        self.layer.borderColor  = XCOLOR(204, 204, 204).CGColor;
        self.layer.borderWidth = 0.5;
        
        //1、提示信息
        self.tipLab = [UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR(137, 137, 137) TextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.tipLab];
        self.tipLab.numberOfLines = 0;
 
        
        //2、了解详情
        self.moreLab =[UILabel labelWithFontsize:KDUtilSize(13) TextColor:XCOLOR_RED TextAlignment:NSTextAlignmentRight];
        self.moreLab.text = @"了解详情";
        [self addSubview:self.moreLab];
        
        
        //3、箭头
        self.arrowView =[[UIImageView alloc] init];
        self.arrowView.image = [UIImage imageNamed:@"TJ_arrow"];
        self.arrowView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.arrowView];
        
        //点击手势，用于页面跳转
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

-(void)setTipStr:(NSString *)tipStr{

    _tipStr = tipStr;
 
    self.tipLab.text = tipStr;
    CGSize tipSize = [self getContentBoundWithTitle:tipStr andFontSize:KDUtilSize(13) andMaxWidth:(XScreenWidth - 40)];
    CGFloat tipY = 10;
    CGFloat tipW = tipSize.width;
    CGFloat tipX =  0.5 * (self.bounds.size.width  - tipW);
    CGFloat tipH = tipSize.height;
    self.tipLab.frame = CGRectMake(tipX, tipY, tipW, tipH);
    
    self.contentHeigt =  tipSize.height + 40;
    
}



-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}


-(void)layoutSubviews{
   
    [super layoutSubviews];
    
    CGSize titleSize = [self.moreLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:KDUtilSize(13)]];
    CGFloat moreW =  self.bounds.size.width - 20;
    CGFloat moreX =  0;
    CGFloat moreH =  titleSize.height;
    CGFloat moreY =  self.bounds.size.height - moreH - 10;
    self.moreLab.frame = CGRectMake(moreX, moreY, moreW, moreH);
    
    
    CGFloat arrowX =  CGRectGetMaxX(self.moreLab.frame);
    CGFloat arrowH =  moreH;
    CGFloat arrowW =  arrowH;
    CGFloat arrowY =  moreY;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);

}


-(void)onClick{

    if (self.actionBlock) {
        
        self.actionBlock();
    }
}


@end
