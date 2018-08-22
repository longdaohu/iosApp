//
//  RoomItemHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemHeaderView.h"
#import "SDCycleScrollView.h"
#import "UIButton+WebCache.h"

@interface RoomItemHeaderView ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)UIView *crossView;
@property(nonatomic,strong)UIView *boxView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *mapView;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *unitLab;
@property(nonatomic,strong)UILabel *numberLab;
@property(nonatomic,strong)UILabel *addressLab;
@property(nonatomic,strong)UIButton *countBtn;
@property(nonatomic,strong)SDCycleScrollView *bannerView;

@end

@implementation RoomItemHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_CLEAR;
        
        UIView *cross = [UIView new];
        cross.backgroundColor = XCOLOR_RANDOM;
        [self addSubview:cross];
        self.crossView = cross;
        
        UIButton *countBtn = [UIButton new];
        [countBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        countBtn.backgroundColor = XCOLOR_WHITE;
        countBtn.titleLabel.font = XFONT(12);
        [self addSubview:countBtn];
        self.countBtn = countBtn;
        countBtn.layer.cornerRadius = CORNER_RADIUS;
        
        UIView *bg = [UIView new];
        bg.backgroundColor = XCOLOR_WHITE;
        [self addSubview:bg];
        self.bgView = bg;
        
        UIView *box = [UIView new];
        box.backgroundColor = XCOLOR_WHITE;
        [self addSubview:box];
        self.boxView = box;
        box.layer.shadowColor = XCOLOR_BLACK.CGColor;
        box.layer.shadowOffset = CGSizeMake(0, 3);
        box.layer.shadowOpacity = 0.5;
        box.layer.cornerRadius = CORNER_RADIUS;
 
        UIView *line = [UIView new];
        line.backgroundColor = XCOLOR_line;
        [box addSubview:line];
        self.line = line;
 
        UIImageView *map = [UIImageView new];
        map.backgroundColor = XCOLOR_BG;
        map.clipsToBounds = YES;
        map.contentMode = UIViewContentModeScaleAspectFill;
        [box addSubview:map];
        self.mapView = map;
        map.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(caseMap)];
        [map addGestureRecognizer:tap];
        
        UILabel *title = [UILabel new];
        title.numberOfLines = 0;
        title.textColor = XCOLOR_TITLE;
        self.titleLab = title;
        [box addSubview:title];
        
        UILabel *price = [UILabel new];
        price.textColor = XCOLOR_RED;
        self.priceLab = price;
        [box addSubview:price];
        
        UILabel *unit = [UILabel new];
        unit.textColor = XCOLOR_SUBTITLE;
        self.unitLab = unit;
        [box addSubview:unit];
        
        UILabel *num = [UILabel new];
        num.textColor = XCOLOR_SUBTITLE;
        num.textAlignment = NSTextAlignmentRight;
        self.numberLab = num;
        [box addSubview:num];
 
        UILabel *add = [UILabel new];
        add.textColor = XCOLOR_SUBTITLE;
        self.addressLab = add;
        add.numberOfLines = 0;
        [box addSubview:add];
        
        self.clipsToBounds = YES;
        
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
        [self.crossView addSubview:_bannerView];
    }
    
    return _bannerView;
}

- (void)setItemFrameModel:(RoomItemFrameModel *)itemFrameModel{
    _itemFrameModel = itemFrameModel;
    
    self.crossView.frame = itemFrameModel.cross_frame;
    self.boxView.frame = itemFrameModel.header_box_frame;
    self.bgView.frame = itemFrameModel.header_bg_frame;
    self.titleLab.frame = itemFrameModel.title_frame;
    self.line.frame = itemFrameModel.line_frame;
    self.priceLab.frame = itemFrameModel.price_frame;
    self.unitLab.frame = itemFrameModel.unit_frame;
    self.numberLab.frame = itemFrameModel.id_frame;
    self.mapView.frame = itemFrameModel.map_frame;
    self.addressLab.frame = itemFrameModel.address_frame;
 
    NSString *path = itemFrameModel.item.minimap;
    [self.mapView sd_setImageWithURL:[NSURL URLWithString:path]  placeholderImage:nil];
    
    self.titleLab.font = XFONT(itemFrameModel.header_title_font_size);
    self.titleLab.text = itemFrameModel.item.name;
    
    self.priceLab.font = XFONT(itemFrameModel.header_price_font_size);
    self.priceLab.text = itemFrameModel.item.price;
    
    self.unitLab.text = itemFrameModel.item.unit;
    self.unitLab.font = XFONT(itemFrameModel.header_unit_font_size);
    
    self.numberLab.text = itemFrameModel.item.roomCode;
    self.numberLab.font = XFONT(itemFrameModel.header_id_font_size);
    
    self.addressLab.text = itemFrameModel.item.address;
    self.addressLab.font = XFONT(itemFrameModel.header_address_font_size);
    
    for (NSInteger index = 0; index < itemFrameModel.item.feature.count; index++) {
        
        UIButton * item = [UIButton new];
        [item setTitle:itemFrameModel.item.feature[index] forState:UIControlStateNormal];
        [item setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        item.titleLabel.font = XFONT(itemFrameModel.tag_font_size);
        [self.boxView addSubview:item];
        NSString *clr = index % 2 ? @"button_red_nomal" : @"button_blue_nomal";
        [item setBackgroundImage:XImage(clr) forState:UIControlStateNormal];
        NSValue *item_value = itemFrameModel.headerTagFrames[index];
        item.frame = item_value.CGRectValue;
        item.clipsToBounds = true;
    }
 
    if (itemFrameModel.item.imageURLs > 0) {
        self.bannerView.frame = self.crossView.bounds;
        self.bannerView.imageURLStringsGroup = itemFrameModel.item.imageURLs;
        
        self.countBtn.frame = itemFrameModel.count_frame;
        NSString *count = [NSString stringWithFormat:@"1/%ld",itemFrameModel.item.imageURLs.count];
        [self.countBtn setTitle:count forState:UIControlStateNormal];
        
    }
 
}

#pragma mark : SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSString *count = [NSString stringWithFormat:@"%ld/%ld",(index+1),self.itemFrameModel.item.imageURLs.count];
    [self.countBtn setTitle:count forState:UIControlStateNormal];
}

- (void)caseMap{
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}


@end
