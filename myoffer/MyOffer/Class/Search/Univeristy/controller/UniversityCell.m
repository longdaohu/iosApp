//
//  UniversityCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityCell.h"

@implementation UniversityCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    UniversityCell *cell =[tableView dequeueReusableCellWithIdentifier:@"universityItem"];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"UniversityCell" owner:self options:nil].lastObject;
     }
    return cell;
}

- (void)awakeFromNib {
    
    
    self.logo =[[LogoView alloc] init];
    [self.contentView addSubview:self.logo];
    
    self.nameLab = [UILabel labelWithFontsize:XPERCENT * 15  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLab];
    
    self.officalLab =  [UILabel labelWithFontsize:XPERCENT * 11  TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.officalLab];
    self.officalLab.numberOfLines = 2;
    
    
    self.addressLab =  [UILabel labelWithFontsize:XPERCENT * 11  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.addressLab];
    
    self.qsLab =  [UILabel labelWithFontsize:XPERCENT * 11  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.qsLab];

    self.localLab =  [UILabel labelWithFontsize:XPERCENT * 11  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.localLab];
    
    self.anthorView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Uni_anthor"]];
    self.anthorView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.anthorView];
    
    self.hotView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_cn"]];
    self.hotView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.hotView];
    
    
    self.paddingView =[[UIView alloc] init];
    self.paddingView.backgroundColor = BACKGROUDCOLOR;
    [self.contentView addSubview:self.paddingView];

    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setItemFrame:(UniItemFrame *)itemFrame{

    _itemFrame = itemFrame;
    
    UniversityItemNew *item = itemFrame.item;
   
    
    [self.logo.logoImageView sd_setImageWithURL:[NSURL URLWithString:item.logo]];
    self.nameLab.text = item.name;
    self.officalLab.text = item.official_name;
    self.addressLab.text = item.address_detail;
    NSString *ranking_qs = item.ranking_qs.integerValue == DefaultNumber ? @"暂无排名" : [NSString stringWithFormat:@"%@",item.ranking_qs];
    self.qsLab.text = [NSString stringWithFormat:@"世界排名: %@",ranking_qs];
    NSString *local_rank_name  =  [itemFrame.item.country  containsString:@"英"] ? [NSString stringWithFormat:@"%@",item.ranking_ti] : [NSString stringWithFormat:@"%@星",item.ranking_ti];
    self.localLab.text = [NSString stringWithFormat:@"本地排名: %@",local_rank_name];
    self.hotView.hidden = (item.hot == 0);
    
    CGFloat addressWidth = [item.address_detail KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
    if (addressWidth > (itemFrame.address_detailFrame.size.width - 30)) {
        self.addressLab.text = [NSString stringWithFormat:@" %@ | %@",itemFrame.item.country,itemFrame.item.city];
    }
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

    CGRect LogoFrame = self.logo.frame;
    LogoFrame = self.itemFrame.logoFrame;
    self.logo.frame = LogoFrame;
    
    
    CGRect nameFrame = self.nameLab.frame;
    nameFrame = self.itemFrame.nameFrame;
    self.nameLab.frame = nameFrame;
    
    
    CGRect officalFrame = self.officalLab.frame;
    officalFrame = self.itemFrame.official_nameFrame;
    self.officalLab.frame = officalFrame;
    
 
    CGRect anthorFrame = self.anthorView.frame;
    anthorFrame = self.itemFrame.anchorFrame;
    self.anthorView.frame = anthorFrame;
    
 
    CGRect addressFrame = self.addressLab.frame;
    addressFrame = self.itemFrame.address_detailFrame;
    self.addressLab.frame = addressFrame;
    
    
    CGRect qsFrame = self.qsLab.frame;
    qsFrame = self.itemFrame.QSRankFrame;
    self.qsLab.frame = qsFrame;
    
    
    CGRect localFrame = self.localLab.frame;
    localFrame = self.itemFrame.TIMESRankFrame;
    self.localLab.frame = localFrame;
    
    
    CGRect hotFrame = self.hotView.frame;
    hotFrame = self.itemFrame.hotFrame;
    self.hotView.frame = hotFrame;
    
    
  
}



@end