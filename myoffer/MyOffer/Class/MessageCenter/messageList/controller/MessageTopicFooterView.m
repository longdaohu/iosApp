//
//  MessageTopicFooterView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageTopicFooterView.h"

@interface MessageTopicFooterView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIButton *titleBtn;
@end

@implementation MessageTopicFooterView
+ (instancetype)fooerWithTitle:(NSString *)title action:(MessageTopicFooterViewBlock)actionBlock{
    
    MessageTopicFooterView *fooer = [[MessageTopicFooterView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH,60)];
    
    fooer.title = [NSString stringWithFormat:@"查看更多%@资讯",title];
    
    fooer.actionBlock = actionBlock;
    
    
    return fooer;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        self.bgView = bgView;
        bgView.backgroundColor = XCOLOR_BG;
        
        UIButton *titleBtn = [UIButton new];
        self.titleBtn = titleBtn;
        [self.bgView addSubview:titleBtn];
        [titleBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:15];
        [titleBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)onClick:(UIButton *)sender{

    if (self.actionBlock) {
        
        self.actionBlock();
    }
}

- (void)setTitle:(NSString *)title{

    _title = title;

    [self.titleBtn setTitle:title forState:UIControlStateNormal];
    
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    
    CGSize contentSize = self.bounds.size;
    
    self.bgView.frame = self.bounds;
    
    self.titleBtn.frame = CGRectMake(0, 0, XSCREEN_WIDTH,contentSize.height - 10);
  
    
}


@end
