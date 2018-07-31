//
//  RoomItemBookSV.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemBookSV.h"
#import "Masonry.h"

@implementation RoomItemBookSV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
        UIView *bgView = [[UIView alloc] init];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.mas_left).mas_offset(20);
            make.right.mas_equalTo(self.mas_right).mas_offset(-20);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.bottom);
            
        }];
        
        UILabel *aLab = [self makeLabelWithText:@"租金/周" superView:bgView];
        UILabel *bLab = [self makeLabelWithText:@"起租租期" superView:bgView];
        UILabel *cLab = [self makeLabelWithText:@"开始时间" superView:bgView];
        UILabel *dLab = [self makeLabelWithText:@" " superView:bgView];
        [@[aLab, bLab,cLab,dLab] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [@[aLab, bLab,cLab,dLab] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_top);
            make.bottom.mas_equalTo(bgView.mas_bottom);
            make.width.mas_equalTo(aLab.mas_width);
        }];
    }
    return self;
}

- (UILabel *)makeLabelWithText:(NSString *)text  superView:(UIView *)superView{
    
    UILabel *sender = [UILabel new];
    sender.font = [UIFont boldSystemFontOfSize:14];
    sender.textColor = XCOLOR_TITLE;
    sender.text = text;
    sender.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:sender];
    
    return sender;
}


@end
