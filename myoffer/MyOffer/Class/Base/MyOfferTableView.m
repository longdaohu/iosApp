//
//  MyOfferTableView.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferTableView.h"

@interface MyOfferTableView ()
@property(nonatomic,strong)UIView  *bgView;
@property(nonatomic,assign)BOOL  isSeted;

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

    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
     self.bgView = bgView;
    
    [bgView addSubview:self.emptyView];
    
    self.emptyView.center = bgView.center;
    
    self.emptyY = DEFAULT_NUMBER;
    
}


- (EmptyDataView *)emptyView{

    if (!_emptyView) {
        
        _emptyView  = [EmptyDataView emptyViewWithBlock:nil];
       
    }
    
    return _emptyView;
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
    
    self.bgView.mj_h = bg_height;
  
    self.tableFooterView = self.bgView;
    
 
    if (self.emptyY != DEFAULT_NUMBER) {
        
        self.emptyView.mj_y = self.emptyY;
        
        return;
    }
    
    self.emptyView.center = self.bgView.center;
    
    
}

- (void)setBtn_title:(NSString *)btn_title{
    
    _btn_title = btn_title;
    
    self.emptyView.btn_title = btn_title;
}

- (void)emptyViewWithError:(NSString *)error{
    
    self.emptyView.errorStr =  error;
    
    [self emptyViewWithHiden:NO];

}

- (void)setEmpty_icon:(NSString *)empty_icon{
    
    _empty_icon  = empty_icon;
    
    self.emptyView.icon = empty_icon;
    
}


@end

