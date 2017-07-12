//
//  MyofferSectionView.m
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/5.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import "MyofferSectionView.h"
@interface MyofferSectionView ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView  *panddingView;
@property(nonatomic,strong)UIView  *line_bottom;

@end

@implementation MyofferSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.panddingView = [UIView new];
        self.panddingView.backgroundColor = [UIColor greenColor];
        self.panddingView.layer.cornerRadius = 2.5;
        self.panddingView.layer.masksToBounds = true;
        [self addSubview:self.panddingView];
        
        self.titleLab = [UILabel new];
        [self addSubview:self.titleLab];
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.font = [UIFont systemFontOfSize:16];
        
        
        UIView *line = [UIView new];
        line.backgroundColor = XCOLOR_line;
        [self addSubview:line];
        self.line_bottom = line;
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


- (void)setTitle:(NSString *)title{

    _title = title;
    
    self.titleLab.text = title;
    
}

- (void)bottomLineShow:(BOOL)show{

    self.line_bottom.alpha = show ? 1 : 0;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    self.panddingView.frame = CGRectMake(10, margin , 5, self.bounds.size.height - 2 * margin);
    
    self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.panddingView.frame) + margin, 0, self.bounds.size.width, self.bounds.size.height);
    
    self.line_bottom.frame = CGRectMake(0, self.bounds.size.height - LINE_HEIGHT, self.bounds.size.width, LINE_HEIGHT);
    
}




@end
