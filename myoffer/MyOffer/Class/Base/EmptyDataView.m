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
@property(nonatomic,strong)UILabel *errorLab;

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
        logoView.clipsToBounds = YES;
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        logoView.image = [UIImage imageNamed:@"no_message"];
        [self addSubview:logoView];
        self.logoView = logoView;
        
        
        UILabel *errorLab = [[UILabel alloc] init];
        errorLab.text = @"数据为空";
        errorLab.numberOfLines = 0;
        errorLab.textColor = XCOLOR_LIGHTGRAY;
        errorLab.font = [UIFont systemFontOfSize:14];
        errorLab.textAlignment = NSTextAlignmentCenter;
        self.errorLab = errorLab;
        [self addSubview:errorLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reload)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)reload{
    
    if (self.actionBlock) self.actionBlock();
    
}


- (void)setErrorStr:(NSString *)errorStr{

    _errorStr = errorStr;
    
    self.errorLab.text = errorStr;

}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat logo_X = 0;
    CGFloat logo_Y = 0;
    CGFloat logo_W = self.bounds.size.width;
    CGFloat logo_H = self.bounds.size.height - 100;
     self.logoView.frame = CGRectMake(logo_X, logo_Y, logo_W, logo_H);
    
    
    CGFloat error_X = 0;
    CGFloat error_Y = CGRectGetMaxY(self.logoView.frame);
    CGFloat error_W = logo_W;
    CGFloat error_H = 50;
    self.errorLab.frame = CGRectMake(error_X, error_Y, error_W, error_H);
  
}


@end

