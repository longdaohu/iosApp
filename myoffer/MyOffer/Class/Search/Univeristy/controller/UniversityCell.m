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
//        cell = [[UniversityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"universityItem"];
     }
    return cell;
}

- (void)awakeFromNib {
    
    
    self.nameLab.font = XFONT(KDUtilSize(UNIVERISITYTITLEFONT));
    self.officalLab.font = XFONT(KDUtilSize(UNIVERISITYSUBTITLEFONT));
    self.officalLab.numberOfLines = 2;
    self.addressLab.font = XFONT(KDUtilSize(UNIVERISITYSUBTITLEFONT));
    self.qsLab.font = XFONT(KDUtilSize(UNIVERISITYSUBTITLEFONT));
    self.localLab.font = XFONT(KDUtilSize(UNIVERISITYSUBTITLEFONT));
    
    [super awakeFromNib];
    // Initialization code
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItemFrame:(UniItemFrame *)itemFrame{

    _itemFrame = itemFrame;
    
    UniversityItemNew *item = itemFrame.item;
    
    
    [self.logo.logoImageView sd_setImageWithURL:[NSURL URLWithString:item.logo]];
    self.nameLab.text = item.name;
    self.officalLab.text = item.official_name;
    NSString *addressStr = (XScreenWidth <= 320) ? [NSString stringWithFormat:@"%@ | %@",item.country,item.city] : item.address_detail;
    self.addressLab.text = addressStr;
    self.qsLab.text = [NSString stringWithFormat:@"世界排名: %@",item.global_rank];
    self.localLab.text = [NSString stringWithFormat:@"本地排名: %@",item.local_rank];
    self.hotView.hidden = (item.hot_flag == 0);
    
   
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
