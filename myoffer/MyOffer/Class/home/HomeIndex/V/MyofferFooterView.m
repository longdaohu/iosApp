//
//  MyofferFooterView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyofferFooterView.h"
#import "AppButton.h"

@interface MyofferFooterView ()
@property(nonatomic,strong)AppButton *emptyView;

@end

@implementation MyofferFooterView
+ (instancetype)footer{
    
    MyofferFooterView *footer = [[MyofferFooterView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 10)];
    
    return footer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        AppButton *empty = [AppButton new];
        [empty setTitleColor:XCOLOR_BLACK forState:UIControlStateNormal];
        empty.titleLabel.font = XFONT(16);
        self.emptyView = empty;
        empty.type = MyofferButtonTypeImageTop;
        [empty setImage: XImage(@"no_message") forState:UIControlStateNormal];
        [empty setTitle:@"网络加载失败，点击重新加载。" forState:UIControlStateNormal];
        [empty addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:empty];
        
    }
    return self;
}

- (void)reload{
    
    if(self.actionBlock){
        self.actionBlock();
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize content_size = self.bounds.size;
    
    CGFloat empty_w =  content_size.width;
    CGFloat empty_h =  self.emptyView.currentImage.size.height * empty_w / self.emptyView.currentImage.size.width +  50;
    CGFloat empty_x =  0;
    CGFloat empty_y =  (content_size.height - empty_h) * 0.5;
    self.emptyView.frame = CGRectMake(empty_x, empty_y, empty_w, empty_h);
    
}

@end
