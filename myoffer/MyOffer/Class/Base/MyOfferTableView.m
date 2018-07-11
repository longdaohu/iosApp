//
//  MyOfferTableView.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferTableView.h"
#import "AppButton.h"

@interface MyOfferTableView ()
@property(nonatomic,strong)UIView  *tablefooter;
@property(nonatomic,assign)BOOL  isSeted;
@property(nonatomic,strong)UIButton  *emptyView;

@end

@implementation MyOfferTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        [self makeUI];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self makeUI];
        
    }
    
    return self;
}

- (void)makeUI{
    
    self.backgroundColor = XCOLOR_BG;
    self.emptyY = DEFAULT_NUMBER;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
 

- (UIButton *)emptyView{
    
    if (!_emptyView) {
        
        CGFloat empty_h = 200;
        CGFloat empty_y = (self.bounds.size.height - empty_h) * 0.5;
        AppButton *empty = [[AppButton alloc] initWithFrame: CGRectMake(0, empty_y, self.bounds.size.width, empty_h)];
        [empty setTitleColor:XCOLOR_BLACK forState:UIControlStateNormal];
        empty.titleLabel.font = XFONT(13);
        empty.type = MyofferButtonTypeImageTop;
        [empty setImage: XImage(@"no_message") forState:UIControlStateNormal];
        [empty setTitle:NetRequest_NoDATA forState:UIControlStateNormal];
        [empty addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        
        _emptyView = empty;
    }
    
    return _emptyView;
}

- (void)reload{
  
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (UIView *)tablefooter{
    if (!_tablefooter) {
        
        _tablefooter = [[UIView alloc] initWithFrame:self.bounds];
        [_tablefooter addSubview:self.emptyView];
    }
    
    return _tablefooter;
}

- (void)emptyViewWithHiden:(BOOL)hiden{
    
    self.alpha =1;

    //1 隐藏
    if (hiden) {
    
        self.tableFooterView = [UIView new];
        
        return;
    }
  
    
    CGFloat bg_height = self.mj_h;
    
    if (self.tableHeaderView.mj_h > 0) {
        
        bg_height -= self.tableHeaderView.mj_h;
    }
    
    if (self.mj_y > 0) {
        
        bg_height -= self.mj_y;
    }
    
    if (self.contentInset.top > 0) {
        
        bg_height -= self.contentInset.top;
    }
    
    if (self.contentInset.bottom > 0) {
        
        bg_height -= self.contentInset.bottom;

    }
    
    self.tablefooter.mj_h = bg_height;
    self.tableFooterView = self.tablefooter;
    self.emptyView.center = self.tablefooter.center;

    NSLog(@" emptyY == %lf",self.emptyY);
    if (self.emptyY != DEFAULT_NUMBER) {
        self.emptyView.mj_y = self.emptyY;
        return;
    }
 
}

- (void)setEmptyY:(CGFloat)emptyY{
    
    _emptyY = emptyY;
    
    NSLog(@"bbbbb   emptyY == %lf",emptyY);

}

- (void)setBtn_title:(NSString *)btn_title{
    
    _btn_title = btn_title;
    [self.emptyView setTitle:btn_title forState:UIControlStateNormal];
    
}

- (void)emptyViewWithError:(NSString *)error{
    

    [self.emptyView setTitle:error forState:UIControlStateNormal];
    [self emptyViewWithHiden:NO];

}

- (void)setEmpty_icon:(NSString *)empty_icon{
    
    _empty_icon  = empty_icon;
    
    [self.emptyView setImage:XImage(empty_icon) forState:UIControlStateNormal];
    
}



@end

