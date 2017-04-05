//
//  EmptyDataView.m
//  OfferDemo
//
//  Created by xuewuguojie on 2016/12/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "EmptyDataView.h"


@interface EmptyDataView ()
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UIButton *reloadBtn;

@end


@implementation EmptyDataView

+ (instancetype)emptyViewWithBlock:(EmptyDataViewBlock)actionBlock{
    
    EmptyDataView *empty = [[EmptyDataView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH - 40, 250)];
    
    empty.actionBlock = actionBlock;
    
    return empty;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
 
        UIImageView *logoView = [[UIImageView alloc] init];
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        logoView.image = [UIImage imageNamed:@"no_message"];
        [self addSubview:logoView];
        self.logoView = logoView;
        
        
        UILabel *errorLab = [[UILabel alloc] init];
        errorLab.text = @"数据为空";
        errorLab.numberOfLines = 0;
        errorLab.textColor = XCOLOR_LIGHTGRAY;
        errorLab.font = [UIFont systemFontOfSize:13];
        errorLab.textAlignment = NSTextAlignmentCenter;
        self.errorLab = errorLab;
        [self addSubview:errorLab];
        
        UIButton *reloadBtn =[[UIButton alloc] init];
        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        reloadBtn.backgroundColor = [UIColor lightGrayColor];
        reloadBtn.layer.cornerRadius = CORNER_RADIUS;
        [reloadBtn addTarget:self action:@selector(reloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reloadBtn];
        self.reloadBtn = reloadBtn;
        reloadBtn.hidden =YES;
    }
    return self;
}

- (void)reloadBtnClick{

    
    self.hidden = YES;
    
    if (self.actionBlock) self.actionBlock();
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat logoX = 0;
    CGFloat logoY = 0;
    CGFloat logoW = self.bounds.size.width;
    CGFloat logoH = self.bounds.size.height - 100;
     self.logoView.frame = CGRectMake(logoX, logoY, logoW, logoH);
    
    
    CGFloat errorX = 0;
    CGFloat errorY = CGRectGetMaxY(self.logoView.frame);
    CGFloat errorW = logoW;
    CGFloat errorH = 50;
     self.errorLab.frame = CGRectMake(errorX, errorY, errorW, errorH);
    
    CGFloat reloadY = CGRectGetMaxY(self.errorLab.frame) + 10;
    CGFloat reloadW = 120;
    CGFloat reloadH = 40;
    CGFloat reloadX = 0.5  * (self.bounds.size.width - reloadW);
    self.reloadBtn.frame = CGRectMake(reloadX, reloadY, reloadW, reloadH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

