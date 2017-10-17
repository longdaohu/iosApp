//
//  RankTypeCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankTypeCell.h"

@interface RankTypeCell ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *cnLab;
@property(nonatomic,strong)UILabel *enLab;

@end

@implementation RankTypeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
 
    NSString *identify = NSStringFromClass([RankTypeCell class]);

    RankTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];

    if(!cell){
        
        cell = [[RankTypeCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
 
        UIView *bgView = [UIView new];
        self.bgView = bgView;
        [self.contentView addSubview:bgView];
        
        UIImageView *bgImageView = [[UIImageView alloc] init];
        self.bgImageView = bgImageView;
        bgImageView.layer.cornerRadius = CORNER_RADIUS;
        bgImageView.layer.masksToBounds = true;
        bgImageView.backgroundColor = XCOLOR_Disable;
        [bgView addSubview:bgImageView];
        
        UIImageView *iconView = [UIImageView new];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView = iconView;
        [bgView addSubview:iconView];
        
        UILabel *cnLab = [UILabel label];
        self.cnLab = cnLab;
        cnLab.numberOfLines =2;
        cnLab.font = [UIFont boldSystemFontOfSize:14];
        cnLab.textColor = XCOLOR_TITLE;
        [bgView addSubview:cnLab];
        cnLab.textAlignment = NSTextAlignmentLeft;
        
        UILabel *enLab = [UILabel label];
        self.enLab = enLab;
        enLab.numberOfLines =2;
        enLab.font = [UIFont systemFontOfSize:14];
        enLab.textColor = XCOLOR_TITLE;
        [bgView addSubview:enLab];
        enLab.textAlignment = NSTextAlignmentLeft;
        
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemFrame:(RankTypeItemFrame *)itemFrame{
    
    _itemFrame = itemFrame;
    
    self.bgView.frame = itemFrame.bg_frame;
    self.bgImageView.frame = itemFrame.bgimage_frame;
    self.iconView.frame = itemFrame.icon_frame;
    self.cnLab.frame = itemFrame.cn_frame;
    self.enLab.frame = itemFrame.en_frame;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:itemFrame.item.image_url]];
    self.cnLab.text = itemFrame.item.name;
    self.enLab.text = itemFrame.item.name_en;
    
}


@end
