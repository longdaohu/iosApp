//
//  EmallCatigroyHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "EmallCatigroyHeaderView.h"

@interface EmallCatigroyHeaderView ()
@property(nonatomic,strong)NSArray *lines;
//上部
@property(nonatomic,strong)UIView *upView;
//下部
@property(nonatomic,strong)UIView *bottomView;
//国家地区名称
@property(nonatomic,strong)UILabel *countryLab;



@end

@implementation EmallCatigroyHeaderView
+ (instancetype)headerViewWithFrame:(CGRect)frame{
    
    EmallCatigroyHeaderView *headerView = [[EmallCatigroyHeaderView alloc] initWithFrame:frame];
    
    return headerView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
  
    if (self) [self makeUI];
    
    return self;
}

- (void)makeUI{

    UIView *upView = [[UIView alloc] init];
    self.upView = upView;
    [self addSubview:upView];
    
    UILabel *countryLab = [[UILabel alloc] init];
    countryLab.textColor = XCOLOR_WHITE;
    countryLab.textAlignment = NSTextAlignmentCenter;
    self.countryLab = countryLab;
    countryLab.font = [UIFont systemFontOfSize:30];
//    [upView addSubview:countryLab];
    
    
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    bottomView.backgroundColor = XCOLOR_BG;
    [self addSubview:bottomView];
    
    
}



- (void)setTitle:(NSString *)title{


    _title = title;
    
    self.countryLab.text = title;
    
    [self.countryLab sizeToFit];

}




- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat upW = contentSize.width;
    CGFloat upH = self.upHeight;
    self.upView.frame = CGRectMake(upX, upY, upW, upH);
  
    self.countryLab.center = CGPointMake(self.upView.center.x, upH * 0.6);

    
    if (self.lines.count >=2) {
        
        CGFloat  lineY = self.countryLab.center.y;
        CGFloat  lineW = 60;
        CGFloat  lineH = 2;
        
        CGFloat  leftLineX = CGRectGetMinX(self.countryLab.frame) - lineW - 10;
        CGFloat  rightLineX = CGRectGetMaxX(self.countryLab.frame) + 10;
        
        UIView *leftItem = (UIView *)self.lines.firstObject;
        leftItem.frame = CGRectMake(leftLineX, lineY, lineW, lineH);
        
        UIView *rightItem = (UIView *)self.lines.lastObject;
        rightItem.frame = CGRectMake(rightLineX, lineY, lineW, lineH);
        
    }
    
    
    CGFloat bottomX = 0;
    CGFloat bottomY = upH;
    CGFloat bottomW = contentSize.width;
    CGFloat bottomH = contentSize.height - bottomY;
    self.bottomView.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    
 
}


@end
