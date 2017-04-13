//
//  UniversityCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityCell.h"
#import "UniItemFrame.h"

@implementation UniversityCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    UniversityCell *cell =[tableView dequeueReusableCellWithIdentifier:@"universityItem"];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"UniversityCell" owner:self options:nil].lastObject;
     }
    cell.contentView.backgroundColor = [UIColor whiteColor];

    return cell;
}

- (void)awakeFromNib {
    
    
    self.logo =[[LogoView alloc] init];
    [self.contentView addSubview:self.logo];
    
    self.nameLab = [UILabel labelWithFontsize:Uni_title_FontSize  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLab];
    
    self.officalLab =  [UILabel labelWithFontsize:Uni_subtitle_FontSize  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.officalLab];
    self.officalLab.numberOfLines = 2;
    
    
    self.addressLab =  [UILabel labelWithFontsize:Uni_address_FontSize  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.addressLab];
    
    self.qsLab =  [UILabel labelWithFontsize:Uni_rank_FontSize  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.qsLab];

    self.localLab =  [UILabel labelWithFontsize:Uni_rank_FontSize  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.localLab];
    
    self.anthorView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Uni_anthor"]];
    self.anthorView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.anthorView];
    
    self.hotView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_cn"]];
    self.hotView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.hotView];
    
    
    self.paddingView =[[UIView alloc] init];
    self.paddingView.backgroundColor = XCOLOR_BG;
    [self.contentView addSubview:self.paddingView];

    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

-(void)setItemFrame:(UniItemFrame *)itemFrame{

    _itemFrame = itemFrame;
    
    UniversityNew *item = itemFrame.item;
   
    
    [self.logo.logoImageView sd_setImageWithURL:[NSURL URLWithString:item.logo]];
    self.nameLab.text = item.name;
    self.officalLab.text = item.official_name;
    self.addressLab.text = item.address_long;
    
    self.qsLab.text = [NSString stringWithFormat:@"世界排名: %@",item.ranking_qs_str];
    self.localLab.text =  [NSString stringWithFormat:@"本国排名: %@",item.ranking_ti_str];
    
    self.hotView.hidden = (item.hot == 0);
    
    CGFloat addressWidth = [item.address_long KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
    if (addressWidth > (itemFrame.address_detailFrame.size.width - 30)) {
        self.addressLab.text = item.address_short;
    }
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
 
    self.logo.frame = self.itemFrame.logoFrame;
 
    self.nameLab.frame = self.itemFrame.nameFrame;
 
    self.officalLab.frame = self.itemFrame.official_nameFrame;
  
    self.anthorView.frame = self.itemFrame.anchorFrame;
  
    self.addressLab.frame = self.itemFrame.address_detailFrame;
  
    self.qsLab.frame = self.itemFrame.QSRankFrame;
  
    self.localLab.frame = self.itemFrame.TIMESRankFrame;
  
    self.hotView.frame = self.itemFrame.hotFrame;
   
}


@end
