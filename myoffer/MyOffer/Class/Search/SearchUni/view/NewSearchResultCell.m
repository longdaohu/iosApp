//
//  NewSearchResultCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#import "UILabel+ResizeHelper.h"
#import "NewSearchResultCell.h"


@interface NewSearchResultCell()
  //LOGO图片
@property(nonatomic,strong)LogoView *LogoView;
//推荐标签
@property(nonatomic,strong)UIImageView *hotView;
 //学校名称
@property(nonatomic,strong)UILabel *nameLab;
//主要显示英文学校名称
@property(nonatomic,strong)UILabel *official_nameLab;
 //地理位置
@property(nonatomic,strong)UILabel *rankLabel;
//地理图标
@property(nonatomic,strong)UIImageView *anchorView;
//地理位置
@property(nonatomic,strong)UITextField *address_detail_TF;
 //用于显示 星号图标
@property(nonatomic,strong)UIView *starBackground;

@end


@implementation NewSearchResultCell


+(instancetype)CreateCellWithTableView:(UITableView *)tableView
{
   
    static NSString *Identifier = @"search";
    
    NewSearchResultCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        
        cell =[[NewSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.LogoView =[[LogoView alloc] init];
        [self addSubview:self.LogoView];
        
  
        self.nameLab =[self getLabelWithFontSize:Uni_title_FontSize andTextColor:XCOLOR_BLACK];
        self.nameLab.hidden = USER_EN ? YES : NO;
        
        self.official_nameLab =[self getLabelWithFontSize:Uni_subtitle_FontSize  andTextColor:XCOLOR_BLACK];
        self.official_nameLab.lineBreakMode = NSLineBreakByWordWrapping;
        self.official_nameLab.numberOfLines = 2;
        self.official_nameLab.clipsToBounds = YES;
        
        //地理图标
        self.anchorView =[[UIImageView alloc] init];
        self.anchorView.image = [UIImage imageNamed:@"Uni_anthor"];
        self.anchorView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.anchorView];
        
        //地理位置
        self.address_detail_TF = [[UITextField alloc] init];
        self.address_detail_TF.textColor = XCOLOR_DARKGRAY;
        self.address_detail_TF.font = FontWithSize(Uni_address_FontSize);
        self.address_detail_TF.userInteractionEnabled = NO;
        [self.contentView addSubview:self.address_detail_TF];
        
        
        self.rankLabel =[self getLabelWithFontSize:Uni_rank_FontSize  andTextColor:XCOLOR_DARKGRAY];
        
        self.starBackground =[[UIView alloc] init];
        [self addSubview:self.starBackground];
        
        for (NSInteger i = 0; i<5; i++) {
            
            UIImageView *mv =[[UIImageView alloc] init];
            mv.image = [UIImage imageNamed:@"star"];
            mv.contentMode = UIViewContentModeScaleAspectFill;
            [self.starBackground addSubview:mv];
        }
        
        
        self.optionOrderBy =  RANKTI;
        
        self.contentView.backgroundColor  = [UIColor whiteColor];
        
        
        self.hotView =[[UIImageView alloc] init];
        self.hotView.contentMode =UIViewContentModeScaleAspectFit;
        [self addSubview:self.hotView];
    }
    
    return self;
}

-(UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab =[[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font =[UIFont systemFontOfSize:fontSize];
    
    [self addSubview:Lab];

    return Lab;
}

-(void)setUni_Frame:(UniversityFrameApplyObj *)uni_Frame{

    _uni_Frame  = uni_Frame;
    
    UniversityItemNew *uniObj = uni_Frame.uni;
    
    self.hotView.frame = uni_Frame.hotFrame;
    
    self.LogoView.frame = uni_Frame.LogoFrame;
    [self.LogoView.logoImageView KD_setImageWithURL:uniObj.logo];
    
    self.nameLab.frame = uni_Frame.nameFrame;
    self.nameLab.text = uniObj.name;
    
    self.official_nameLab.text = uniObj.official_name;
    self.official_nameLab.frame = uni_Frame.official_nameFrame;
    
    self.anchorView.frame = uni_Frame.anchorFrame;
    self.address_detail_TF.frame = uni_Frame.address_detailFrame;
    self.address_detail_TF.text = uni_Frame.uni.address_detail;
    
    CGFloat addressWidth = [uniObj.address_detail KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
    
    if (addressWidth > (uni_Frame.address_detailFrame.size.width - 30)) {
        
        self.address_detail_TF.text = uniObj.address_short;
        
     }
    
    self.rankLabel.frame = uni_Frame.RankFrame;
    self.starBackground.hidden = !self.isStart;
    
    self.hotView.image = uni_Frame.uni.hot ? [UIImage imageNamed:GDLocalizedString(@"University-hot")]:[UIImage imageNamed:@""];
    
    if ([self.optionOrderBy isEqualToString:RANKQS]) {
        
        NSString   *rankStr01 = uniObj.ranking_qs.intValue == DefaultNumber ? GDLocalizedString(@"SearchResult_noRank"):[NSString stringWithFormat:@"%@",uniObj.ranking_qs];
        self.rankLabel.text = [NSString stringWithFormat:@"世界排名：%@",rankStr01];
        
        return;
    }
    
    
    if (self.isStart) {
        
        self.starBackground.frame = uni_Frame.starBgFrame;
        CGPoint center = self.starBackground.center;
        center.y = self.rankLabel.center.y;
        self.starBackground.center = center;
        self.rankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        NSInteger  StarCount  = uniObj.ranking_ti.integerValue;
        
        if (StarCount == DefaultNumber) {
            
            self.rankLabel.text = @"本国排名：暂无排名";
            
            return;
        }
        
        for (NSInteger i =0; i < self.starBackground.subviews.count; i++) {
            
            UIImageView *imageV = (UIImageView *)self.starBackground.subviews[i];
            
            imageV.frame = CGRectMake([uni_Frame.starFrames[i] integerValue], 0, 15, 15);
        }
        
        
        for (NSInteger i =0; i < StarCount; i++) {
            
            UIImageView *mv = (UIImageView *)self.starBackground.subviews[i];
            
            mv.hidden = NO;
            
        }
        
        for (NSInteger i = StarCount ; i < self.starBackground.subviews.count; i++) {
            
            UIImageView *mv = (UIImageView *)self.starBackground.subviews[i];
            
            mv.hidden = YES;
        }
        
        
    }else{
        
        NSString   *rankStr01 = uniObj.ranking_ti.intValue == DefaultNumber ? GDLocalizedString(@"SearchResult_noRank"):[NSString stringWithFormat:@"%@",uniObj.ranking_ti];
        self.rankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
        
    }

}


-(void)layoutSubviews
{
    [super layoutSubviews];
  
 
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
