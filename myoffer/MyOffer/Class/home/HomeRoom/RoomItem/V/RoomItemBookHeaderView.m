//
//  RoomItemBookHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemBookHeaderView.h"

@interface RoomItemBookHeaderView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *typeLab;
@property(nonatomic,strong)UILabel *sizeLab;
@property(nonatomic,strong)UILabel *bedLab;
@property(nonatomic,strong)UILabel *noteLab;
@property(nonatomic,strong)UIView *line;

@end

@implementation RoomItemBookHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        UIView *bgView= [UIView new];
        bgView.backgroundColor = XCOLOR_RANDOM;
        self.bgView = bgView;
        [self addSubview:bgView];
        
        UIView *line = [UIView new];
        line.backgroundColor = XCOLOR_line;
        [bgView addSubview:line];
        self.line = line;
 
        UILabel *title = [UILabel new];
        title.numberOfLines = 0;
        title.textColor = XCOLOR_TITLE;
        self.titleLab = title;
        [bgView addSubview:title];
        
        UILabel *type = [UILabel new];
        type.textColor = XCOLOR_RED;
        self.typeLab = type;
        [bgView addSubview:type];
        
        UILabel *sizeLab = [UILabel new];
        sizeLab.textColor = XCOLOR_SUBTITLE;
        self.sizeLab = sizeLab;
        [bgView addSubview:sizeLab];
        
        UILabel *bedLab = [UILabel new];
        bedLab.textColor = XCOLOR_SUBTITLE;
        bedLab.textAlignment = NSTextAlignmentRight;
        self.bedLab = bedLab;
        [bgView addSubview:bedLab];
        
        
        UILabel *noteLab = [UILabel new];
        noteLab.textColor = XCOLOR_SUBTITLE;
        noteLab.textAlignment = NSTextAlignmentRight;
        self.noteLab = noteLab;
        [bgView addSubview:noteLab];
        
    }
    return self;
}

@end
