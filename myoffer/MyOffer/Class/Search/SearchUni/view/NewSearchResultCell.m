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
@property(nonatomic,strong)LogoView *iconView;
//学校名称
@property(nonatomic,strong)UILabel *nameLab;
//主要显示英文学校名称
@property(nonatomic,strong)UILabel *official_nameLab;
//地理图标
@property(nonatomic,strong)UIImageView *anchorView;
//地理位置
@property(nonatomic,strong)UITextField *address_detail_TF;
//排名图标
@property(nonatomic,strong)UIImageView *rankIconView;
//排名
@property(nonatomic,strong) UILabel *rankLab;
 //用于显示 星号图标
@property(nonatomic,strong)UIView *StarsBgView;
//推荐标签
@property(nonatomic,strong)UIImageView *hotView;
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
        
        //LOGO图标
        self.iconView =[[LogoView alloc] init];
        [self addSubview:self.iconView];
        
        //学校名称
        self.nameLab =[self getLabelWithFontSize:XFONT_SIZE(17) andTextColor:XCOLOR_TITLE];
        //学校英文名
        self.official_nameLab =[self getLabelWithFontSize:XFONT_SIZE(13)  andTextColor:XCOLOR_SUBTITLE];
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
        self.address_detail_TF.textColor = XCOLOR_SUBTITLE;
        self.address_detail_TF.font = XFONT(XFONT_SIZE(13));
        self.address_detail_TF.userInteractionEnabled = NO;
        [self.contentView addSubview:self.address_detail_TF];
        
        //排名图标
        UIImageView *rankIconView =[[UIImageView alloc] init];
        self.rankIconView = rankIconView;
        rankIconView.image = [UIImage imageNamed:@"sort-arrows-none"];
        rankIconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:rankIconView];
        
        //排名
        self.rankLab =[self getLabelWithFontSize:XFONT_SIZE(13)  andTextColor:XCOLOR_SUBTITLE];
        
        //**号背景
        self.StarsBgView =[[UIView alloc] init];
        [self.contentView addSubview:self.StarsBgView];
        
        for (NSInteger i = 0; i<5; i++) {
            
            UIImageView *mv =[[UIImageView alloc] init];
            mv.image = [UIImage imageNamed:@"star"];
            mv.contentMode = UIViewContentModeScaleAspectFill;
            [self.StarsBgView addSubview:mv];
        }
        
        
        self.optionOrderBy =  RANK_TI;
        
 
        self.hotView =[[UIImageView alloc] init];
        self.hotView.contentMode =UIViewContentModeScaleAspectFit;
        [self addSubview:self.hotView];
        
        
        self.contentView.backgroundColor  = [UIColor whiteColor];

     }
    
    return self;
}
//label创建共有方法
-(UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab =[[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font =[UIFont systemFontOfSize:fontSize];
    
    [self.contentView addSubview:Lab];

    return Lab;
}

-(void)setUni_Frame:(UniversityFrameNew *)uni_Frame{

    _uni_Frame  = uni_Frame;
    
    MyOfferUniversityModel *uniObj = uni_Frame.universtiy;
    
    self.hotView.frame = uni_Frame.hot_Frame;
    
    self.iconView.frame = uni_Frame.icon_Frame;
    [self.iconView.logoImageView KD_setImageWithURL:uniObj.logo];
    
    self.nameLab.frame = uni_Frame.name_Frame;
    self.nameLab.text = uniObj.name;
    
    self.official_nameLab.text = uniObj.official_name;
    self.official_nameLab.frame = uni_Frame.official_Frame;
    
    
    self.anchorView.frame = uni_Frame.anchor_Frame;
    self.address_detail_TF.frame = uni_Frame.address_Frame;
    self.address_detail_TF.text = uni_Frame.universtiy.address_long;
    
    
    CGFloat addressWidth = [uniObj.address_long KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
     //判断地址字符串太长时，换一个短的地址
    if (addressWidth > (uni_Frame.address_Frame.size.width - 30)) {
        
        self.address_detail_TF.text = uniObj.address_short;
        
     }
    
    self.rankIconView.frame = uni_Frame.rank_Icon_Frame;
    self.rankLab.frame = uni_Frame.rank_Frame;
    self.StarsBgView.hidden = !self.isStart;
    
    self.hotView.image = uni_Frame.universtiy.hot ? [UIImage imageNamed:GDLocalizedString(@"University-hot")]:[UIImage imageNamed:@""];
    
    //当排名方式是 世界排名时，只显示世界排名信息
    if ([self.optionOrderBy isEqualToString:RANK_QS]) {
        
        NSString   *rankStr01 = uniObj.ranking_qs.intValue == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"):[NSString stringWithFormat:@"%@",uniObj.ranking_qs];
        self.rankLab.text = [NSString stringWithFormat:@"世界排名：%@",rankStr01];
        
        self.StarsBgView.hidden = YES;

        return;
    }
    
    //判断是否需要显示*号   澳大利来排名时
    if (self.isStart) {
        
        self.StarsBgView.frame = uni_Frame.starBgFrame;
        CGPoint center = self.StarsBgView.center;
        center.y = self.rankLab.center.y;
        self.StarsBgView.center = center;
        self.rankLab.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        NSInteger  StarCount  = uniObj.ranking_ti.integerValue;
        
        //暂无排名时

        if (StarCount == DEFAULT_NUMBER) {
            
            self.rankLab.text = @"本国排名：暂无排名";
            
            return;
        }
        
        for (NSInteger i =0; i < self.StarsBgView.subviews.count; i++) {
            
            UIImageView *imageV = (UIImageView *)self.StarsBgView.subviews[i];
            
            imageV.frame = CGRectMake([uni_Frame.starFrames[i] integerValue], 0, 15, 15);
        }
        
        
        for (NSInteger i =0; i < StarCount; i++) {
            
            UIImageView *mv = (UIImageView *)self.StarsBgView.subviews[i];
            
            mv.hidden = NO;
            
        }
        
        for (NSInteger i = StarCount ; i < self.StarsBgView.subviews.count; i++) {
            
            UIImageView *mv = (UIImageView *)self.StarsBgView.subviews[i];
            
            mv.hidden = YES;
        }
        
        
    }else{
        //英国排名
        NSString   *rankStr01 = uniObj.ranking_ti.intValue == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"):[NSString stringWithFormat:@"%@",uniObj.ranking_ti];
        self.rankLab.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
        
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
