//
//  RoomItemTypeCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemTypeCell.h"

@interface RoomItemTypeCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UIButton *pinLab;
@property(nonatomic,strong)UIView *topLine;
@end

@implementation RoomItemTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:iconView];
        iconView.backgroundColor = XCOLOR_RANDOM;
        self.iconView = iconView;
        iconView.layer.cornerRadius = CORNER_RADIUS;
        iconView.layer.masksToBounds = true;
        
        UILabel *titleLab = [UILabel new];
        self.titleLab = titleLab;
        titleLab.textColor = XCOLOR_TITLE;
        [self.contentView addSubview:titleLab];
        titleLab.numberOfLines = 2;
        titleLab.backgroundColor = XCOLOR_RANDOM;

        UILabel *priceLab = [UILabel new];
        self.priceLab = priceLab;
        priceLab.textColor = XCOLOR_RED;
        [self.contentView addSubview:priceLab];
 
        UIButton *pinLab = [UIButton new];
        self.pinLab = pinLab;
        [pinLab setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        pinLab.backgroundColor = XCOLOR_RANDOM;
        [self.contentView addSubview:pinLab];
        
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

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    self.titleLab.text = item.name;
    self.priceLab.text = item.price;
    [self.pinLab setTitle:item.state forState:UIControlStateNormal];
    
    self.iconView.frame = itemFrameModel.icon_frame;
    self.titleLab.frame = itemFrameModel.title_frame;
    self.priceLab.frame = itemFrameModel.price_frame;
    self.pinLab.frame = itemFrameModel.pin_frame;
    self.topLine.frame = itemFrameModel.line_frame;
    
    self.titleLab.font = XFONT(itemFrameModel.title_font_size);
    self.pinLab.titleLabel.font = XFONT(itemFrameModel.pin_font_size);
    self.priceLab.font = XFONT(itemFrameModel.price_font_size);
}


@end
