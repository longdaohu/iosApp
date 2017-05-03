//
//  SearchPromptView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/2.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SearchPromptView.h"
@interface SearchPromptView ()
@property(nonatomic,strong)UILabel *promptLab;
@property(nonatomic,strong)UIView *shadowView;
@end


@implementation SearchPromptView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIView *shadowView = [UIView new];
        shadowView.backgroundColor = XCOLOR_LIGHTBLUE;
        [self addSubview:shadowView];
        shadowView.layer.shadowColor = XCOLOR_LIGHTBLUE.CGColor;
        shadowView.layer.shadowOffset = CGSizeMake(0, 3);
        shadowView.layer.shadowOpacity = 0.5;
        shadowView.layer.cornerRadius = 13;
        self.shadowView = shadowView;
        
        _promptLab = [[UILabel alloc] init];
        _promptLab.textAlignment = NSTextAlignmentCenter;
        _promptLab.textColor = XCOLOR_WHITE;
        _promptLab.layer.cornerRadius = 13;
        _promptLab.layer.masksToBounds = YES;
        _promptLab.backgroundColor = XCOLOR_LIGHTBLUE;
        _promptLab.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_promptLab];
      
        
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat prompt_H = 26;
    CGFloat prompt_W = 104;
    CGFloat prompt_X = (self.bounds.size.width - prompt_W) * 0.5;
    CGFloat prompt_Y = 10;
    self.promptLab.frame = CGRectMake(prompt_X, prompt_Y, prompt_W, prompt_H);
    
    self.shadowView.frame = CGRectMake(prompt_X, prompt_Y, prompt_W, prompt_H);
    
}


- (void)promptShowWithCount:(NSInteger)count{
    
    _promptLab.text = [NSString stringWithFormat:@"共 %ld 所学校",count];
    
    
    
}


@end
