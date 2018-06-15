//
//  MyofferFooterView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyofferFooterView.h"

@interface MyofferFooterView ()
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation MyofferFooterView
+ (instancetype)footer{
    
    MyofferFooterView *footer = [[MyofferFooterView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 30)];
    
    return footer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = XCOLOR_RANDOM;
        UILabel *titleLab= [UILabel new];
        titleLab.text = @"我是有底线的";
        titleLab.textColor = XCOLOR_BLACK;
        self.titleLab = titleLab;
        titleLab.font = XFONT(14);
        [self addSubview:titleLab];

    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize content_size = self.bounds.size;
//    if (CGRectEqualToRect(self.titleLab.frame, CGRectZero)) {
//        if (self.titleLab.text.length > 0) {
            CGSize title_size =   [self.titleLab.text stringWithfontSize:14];
            CGFloat title_x = (content_size.width - title_size.width) * 0.5;
            CGFloat title_y = 0;
            self.titleLab.frame = CGRectMake(title_x, title_y, title_size.width, content_size.height);
//        }
//    }
    
}

@end
