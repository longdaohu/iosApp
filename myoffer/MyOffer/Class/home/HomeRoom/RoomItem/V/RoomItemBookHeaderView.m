//
//  RoomItemBookHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemBookHeaderView.h"
#import "Masonry.h"
#import "SDCycleScrollView.h"

@interface RoomItemBookHeaderView ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *typeLab;
@property(nonatomic,strong)UILabel *sizeLab;
@property(nonatomic,strong)UILabel *bedLab;
@property(nonatomic,strong)UILabel *noteLab;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property(nonatomic,strong)UIButton *countBtn;
@end

@implementation RoomItemBookHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        self.clipsToBounds = YES;
        
        UIView *bgView= [UIView new];
        bgView.backgroundColor = XCOLOR_WHITE;
        self.bgView = bgView;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(XSCREEN_WIDTH, 136));
            make.left.bottom.mas_equalTo(self);
        }];
        
        CGFloat left_margin = 20;
        CGFloat width_max = XSCREEN_WIDTH - left_margin * 2;
        UIView *line = [UIView new];
        line.backgroundColor = XCOLOR_line;
        [bgView addSubview:line];
        self.line = line;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width_max, 1));
            make.left.mas_equalTo(left_margin);
            make.bottom.mas_equalTo(-48);

        }];
 
        UILabel *title = [UILabel new];
        title.numberOfLines = 0;
        title.textColor = XCOLOR_TITLE;
        self.titleLab = title;
        title.font = [UIFont boldSystemFontOfSize:18];
        [bgView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width_max, 58));
            make.left.mas_equalTo(line.mas_left);
            make.top.mas_equalTo(bgView);
        }];
        
        UILabel *type = [UILabel new];
        type.textColor = XCOLOR_TITLE;
        self.typeLab = type;
        [bgView addSubview:type];
        type.font = XFONT(12);
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width_max * 0.5);
            make.left.mas_equalTo(line.mas_left);
            make.top.mas_equalTo(title.mas_bottom);
        }];
        
        
        UILabel *sizeLab = [UILabel new];
        sizeLab.textColor = XCOLOR_TITLE;
        self.sizeLab = sizeLab;
        sizeLab.font = XFONT(12);
        [bgView addSubview:sizeLab];
        [sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(type.mas_width);
            make.height.mas_equalTo(type.mas_height);
            make.left.mas_equalTo(type.mas_right);
            make.top.mas_equalTo(type.mas_top);
        }];
        
        
        UILabel *bedLab = [UILabel new];
        bedLab.textColor = XCOLOR_TITLE;
        self.bedLab = bedLab;
        [bgView addSubview:bedLab];
        bedLab.font = XFONT(12);
        [bedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(type.mas_width);
            make.height.mas_equalTo(type.mas_height);
            make.left.mas_equalTo(type.mas_left);
            make.top.mas_equalTo(line.mas_bottom).offset(10);
        }];
        
        
        UILabel *noteLab = [UILabel new];
        noteLab.textColor = XCOLOR_TITLE;
        self.noteLab = noteLab;
        [bgView addSubview:noteLab];
        noteLab.font = XFONT(12);
        [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(type.mas_width);
            make.height.mas_equalTo(type.mas_height);
            make.left.mas_equalTo(type.mas_right);
            make.top.mas_equalTo(bedLab.mas_top);
        }];
        
 
        UIButton *countBtn = [UIButton new];
        [countBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        countBtn.backgroundColor = XCOLOR_WHITE;
        countBtn.titleLabel.font = XFONT(12);
        [self addSubview:countBtn];
        self.countBtn = countBtn;
        countBtn.layer.cornerRadius = CORNER_RADIUS;
        [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(50, 20));
            make.right.mas_equalTo(self.mas_right).offset(-left_margin);
            make.bottom.mas_equalTo(bgView.mas_top).offset(-20);
        }];
        
        
    }
    return self;
}

- (SDCycleScrollView *)bannerView{
    
    if (!_bannerView) {
        
        _bannerView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
        _bannerView.bannerImageViewContentMode =  UIViewContentModeScaleAspectFill;
        _bannerView.showPageControl = false;
        _bannerView.clickItemOperationBlock = ^(NSInteger index) {
            //            NSString *target  = target_arr[index];
        };
        [self insertSubview:_bannerView belowSubview:self.countBtn];
    }
    
    return _bannerView;
}


- (void)setItemFrameModel:(RoomTypeItemFrameModel *)itemFrameModel{
  
    _itemFrameModel = itemFrameModel;
    
    self.titleLab.text = itemFrameModel.item.name;
    self.typeLab.text  = [NSString stringWithFormat:@"房型  %@",itemFrameModel.item.type];
    self.sizeLab.text  = [NSString stringWithFormat:@"面积  大约%@平米",itemFrameModel.item.size];
    self.bedLab.text  =  [NSString stringWithFormat:@"床型  %@",itemFrameModel.item.bed];
    self.noteLab.text  = [NSString stringWithFormat:@"备注  %@",itemFrameModel.item.desc];
 
    if (itemFrameModel.item.pictures > 0) {
        self.bannerView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_WIDTH);
        self.bannerView.imageURLStringsGroup = itemFrameModel.item.pictures;
        
        NSString *count = [NSString stringWithFormat:@"1/%ld",self.itemFrameModel.item.pictures.count];
        [self.countBtn setTitle:count forState:UIControlStateNormal];
    }
    
}


#pragma mark : SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSString *count = [NSString stringWithFormat:@"%ld/%ld",(index+1),self.itemFrameModel.item.pictures.count];
    [self.countBtn setTitle:count forState:UIControlStateNormal];
}




@end
