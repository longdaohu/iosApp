//
//  RoomItemTypeCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemTypeCell.h"

@interface RoomItemTypeCell ()
//@property(nonatomic,strong)UIImageView *iconView;
//@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *unitLab;
@property(nonatomic,strong)UIButton *tagLab;
@property(nonatomic,strong)UIView *topLine;
@end

@implementation RoomItemTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.cornerRadius = CORNER_RADIUS;
        self.imageView.layer.masksToBounds = true;
        
        self.textLabel.textColor = XCOLOR_TITLE;
        self.textLabel.numberOfLines = 2;

        UILabel *priceLab = [UILabel new];
        self.priceLab = priceLab;
        priceLab.textColor = XCOLOR_RED;
        [self.contentView addSubview:priceLab];
 
        UILabel *unitLab = [UILabel new];
        self.unitLab = unitLab;
        unitLab.textColor = XCOLOR_TITLE;
        [self.contentView addSubview:unitLab];
        
        UIButton *tagLab = [UIButton new];
        self.tagLab = tagLab;
        [tagLab setTitleColor:XCOLOR(255, 159, 0, 1)  forState:UIControlStateNormal];
        [tagLab setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR(255, 246, 217, 1)] forState:UIControlStateNormal];
        [tagLab setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateDisabled];
        [tagLab setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_BG] forState:UIControlStateDisabled];
        [self.contentView addSubview:tagLab];
        tagLab.layer.cornerRadius = 2;
        
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = XCOLOR_line;
        self.topLine = bottomLine;
        [self.contentView addSubview:bottomLine];
    }
    
    return self;
}

- (void)setItemFrameModel:(RoomTypeItemFrameModel *)itemFrameModel{
    
    _itemFrameModel = itemFrameModel;
    
    RoomTypeItemModel *item = itemFrameModel.item;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:PLACE_HOLDER_IMAGE];
    self.textLabel.text = item.name;
    self.priceLab.text = item.firstPrice.priceCurrency;
    self.unitLab.text = item.firstPrice.unit;
    NSString *title = item.firstPrice.currentState;
    [self.tagLab setTitle:item.firstPrice.currentState forState:UIControlStateNormal];
    self.tagLab.enabled = !item.firstPrice.state.boolValue;
    self.tagLab.hidden = !title ? YES : NO;
    
    self.textLabel.font = XFONT(itemFrameModel.title_font_size);
    self.tagLab.titleLabel.font = XFONT(itemFrameModel.pin_font_size);
    self.priceLab.font = [UIFont boldSystemFontOfSize:itemFrameModel.price_font_size];
    self.unitLab.font = XFONT(itemFrameModel.unit_font_size);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.itemFrameModel) {
        self.imageView.frame = self.itemFrameModel.icon_frame;
        self.textLabel.frame = self.itemFrameModel.title_frame;
        self.priceLab.frame = self.itemFrameModel.price_frame;
        self.unitLab.frame = self.itemFrameModel.unit_frame;
        self.tagLab.frame = self.itemFrameModel.pin_frame;
        self.topLine.frame = self.itemFrameModel.line_frame;
    }
    
}


@end
