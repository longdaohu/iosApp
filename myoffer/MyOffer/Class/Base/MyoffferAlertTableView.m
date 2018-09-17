//
//  MyoffferAlertTableView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/12.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyoffferAlertTableView.h"
#import "EmptyDataView.h"

@interface MyoffferAlertTableView ()
@property(nonatomic,strong)UIView  *tableFooter;
@property(nonatomic,strong)EmptyDataView *alertView;

@end

@implementation MyoffferAlertTableView

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
    
    self.backgroundColor = [UIColor lightGrayColor];
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

- (UIView *)tableFooter{
    
    if (!_tableFooter) {
        
        UIView *tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
        _tableFooter = tableFooter;
        tableFooter.backgroundColor = XCOLOR_WHITE;
        [_tableFooter addSubview:self.alertView];
        _tableFooter.clipsToBounds = YES;
    }
    
    return _tableFooter;
}

- (EmptyDataView *)alertView{
    
    if (!_alertView) {
        
        WeakSelf;
        _alertView = [EmptyDataView emptyViewWithBlock:^{
            [weakSelf caseReload];
        }];
    }
    
    return _alertView;
}


- (void)alertViewHiden{
    
    self.tableFooterView = [UIView new];
}

- (void)alertWithNotDataMessage:(NSString *)message{
    
    self.alertView.alertTitle =  message ? message : @"当前数据为空";
    self.alertView.alertType =   TableViewAlertTypeDefault;
    [self fixFooter];
}

- (void)alertWithRoloadMessage:(NSString *)message{
    
    self.alertView.alertTitle = @"网络加载失败";
    self.alertView.alertMessage = message ? message : @"请再次刷新或检查网络";
    self.alertView.alertType =   TableViewAlertTypeReload;
    [self fixFooter];
}

- (void)alertWithNetworkFailure{
    
    self.alertView.alertTitle = @"网络加载失败";
    self.alertView.alertMessage = @"请检查网络是否连接";
    self.alertView.alertType =   TableViewAlertTypeFailure;
    [self fixFooter];
}

- (void)fixFooter{
    
    
    CGFloat table_y =  self.mj_y;
    CGFloat table_top = self.contentInset.top;
    CGFloat table_header_height = self.tableHeaderView.mj_h;
    CGFloat content_top = (table_y + table_top + table_header_height);
    
    CGFloat footer_height = XSCREEN_HEIGHT - content_top - XNAV_HEIGHT;
    CGFloat alert_center_y = XSCREEN_HEIGHT*0.5 - content_top;
    if (alert_center_y < self.alertView.mj_h * 0.5 || alert_center_y + self.alertView.mj_h > footer_height) {
        
        alert_center_y = self.alertView.mj_h * 0.5;
        footer_height = self.alertView.mj_h;
    }
    if (self.footerHeight) {
        self.footerHeight =   self.footerHeight >= 250 ? self.footerHeight : 250;
        footer_height = self.footerHeight;
    }
    
    self.tableFooter.frame = CGRectMake(0, 0, XSCREEN_WIDTH, footer_height);
    self.alertView.center = CGPointMake( self.tableFooter.center.x, alert_center_y);
    
    self.tableFooterView = self.tableFooter;
    
}

- (void)caseReload{
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}



@end





