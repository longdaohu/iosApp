//
//  MyOfferTableView.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferTableView.h"
#import "EmptyDataView.h"

@interface MyOfferTableView ()
@property(nonatomic,strong)EmptyDataView  *emptyView;
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
    
    self.emptyView  =[EmptyDataView emptyViewWithBlock:^{
        
        if (self.actionBlock) self.actionBlock();
        
    }];
    
    
    [bgView addSubview:self.emptyView];
    
    self.emptyView.center = bgView.center;
    
}

- (void)emptyViewWithHiden:(BOOL)hiden{
    
    //1 隐藏
    if (hiden) {
    
        self.tableFooterView = [UIView new];
        
        return;
    }
    
    
    if (!self.isSeted && (self.tableHeaderView.mj_h || self.mj_y > 0 || self.contentInset.top > 0)) {
        
        self.isSeted = YES;
        
        self.bgView.mj_h = (self.mj_h - self.tableHeaderView.mj_h - self.mj_y - self.contentInset.top);
        
        self.emptyView.mj_y  -= (self.tableHeaderView.mj_h  * 0.5 + 64);
        
        if (self.emptyView.mj_y >= 0) {
            
            self.emptyView.mj_y = 0;
        }
        
    }
    
    self.tableFooterView = self.bgView;
    
}

- (void)emptyViewWithError:(NSString *)error{
    
     self.emptyView.errorStr =  error;
    
    [self emptyViewWithHiden:NO];

}

@end
