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
    
    
//    if (self.tableHeaderView.mj_h > 0 || self.mj_y > 0 || self.contentInset.top > 0) {
//
////        if (!self.isSeted && (self.tableHeaderView.mj_h || self.mj_y > 0 || self.contentInset.top > 0)) {
////        self.isSeted = YES;
//        
//        self.bgView.mj_h = (self.mj_h - self.tableHeaderView.mj_h - self.mj_y - self.contentInset.top);
//        
//        self.emptyView.mj_y  -= (self.tableHeaderView.mj_h  * 0.5 + 64);
//        
//        if (self.emptyView.mj_y >= 0) {
//            
//            self.emptyView.mj_y = 0;
//        }
//        
//    }
    
    
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
    
//    NSLog(@">>>>>aaaaa>>>>> %lf  %lf  %lf",self.emptyView.center.y,self.bgView.center.y,self.center.y);

    self.emptyView.center = self.bgView.center;
    
    
//    if (self.emptyView.center.y == self.center.y) {
//        
//        self.emptyView.center = self.bgView.center;
//        
//    }else{
//    
//        if (self.emptyView.center.y < self.center.y) {
//            
//            CGFloat distance = self.center.y -  self.emptyView.center.y;
//            
//            self.emptyView.center = CGPointMake(self.bgView.center.x, self.bgView.center.y - distance);
//        }
//        
//    }
//    
    
    
}

- (void)emptyViewWithError:(NSString *)error{
    
     self.emptyView.errorStr =  error;
    
    [self emptyViewWithHiden:NO];

}

@end
//2017-07-31 18:44:07.378338+0800 myOffer[983:206581] >>>>>aaaaa>>>>> 301.500000  301.500000  301.500000
//2017-07-31 18:44:18.404405+0800 myOffer[983:206581] >>>>>aaaaa>>>>> 301.500000  276.500000  301.500000
//2017-07-31 18:47:11.457196+0800 myOffer[989:207577] >>>>>aaaaa>>>>> 333.500000  333.500100  333.500000
//2017-07-31 18:48:26.242002+0800 myOffer[989:207577] >>>>>aaaaa>>>>> 333.500000  252.250000  333.500000
//2017-07-31 18:49:36.438497+0800 myOffer[989:207577] >>>>>aaaaa>>>>> 333.500000  241.500000  333.500000


