//
//  myofferAnchorButton.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "myofferAnchorButton.h"
@interface myofferAnchorButton()
@property(nonatomic,strong)UIButton *titleBtn;
@property(nonatomic,strong)UIButton *anchorView;
@end

@implementation myofferAnchorButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        self.titleBtn = titleBtn;
        [self addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(titleOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *anchorView = [[UIButton alloc] initWithFrame:CGRectZero];
        [anchorView setImage:XImage(@"arrow_down") forState:UIControlStateNormal];
        [anchorView setImage:XImage(@"arrow_up") forState:UIControlStateSelected];
        [anchorView sizeToFit];
        self.anchorView = anchorView;
        [self addSubview:anchorView];
        [anchorView addTarget:self action:@selector(titleOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{

    _title = title;
    
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
    
    [self.titleBtn sizeToFit];
    
    self.anchorView.mj_x = self.titleBtn.mj_w + 5;
    CGFloat height = self.titleBtn.mj_h;
    self.anchorView.mj_h =  height;
    CGFloat width = CGRectGetMaxX(self.anchorView.frame);
    self.frame = CGRectMake(0, 0, width, height);
 
}

- (void)titleOnClick:(UIButton *)sender{

    self.titleBtn.selected = !self.titleBtn.selected;
    self.anchorView.selected = !self.anchorView.selected;
    
    if (self.actionBlock)  self.actionBlock(self.titleBtn);
    
}


- (void)titleButtonOnClick{
 
    [self titleOnClick:self.titleBtn];
}


@end
