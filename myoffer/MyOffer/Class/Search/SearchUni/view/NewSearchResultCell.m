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
//地理位置
@property(nonatomic,strong)UIButton *addressBtn;
//排名图标
@property(nonatomic,strong)UIButton *rankBtn;
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
        
        //排名
        UIButton *rankBtn = [[UIButton alloc] init];
        [rankBtn setTitleColor: XCOLOR_SUBTITLE forState:UIControlStateNormal];
        rankBtn.titleLabel.font = XFONT(XFONT_SIZE(13));
        [rankBtn setImage:[UIImage imageNamed:@"sort-arrows-none"]  forState:UIControlStateNormal];
        [self.contentView addSubview:rankBtn];
        self.rankBtn = rankBtn;
        [rankBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        rankBtn.userInteractionEnabled = NO;
        
        //地理位置
        UIButton *address_Btn = [[UIButton alloc] init];
        [address_Btn setTitleColor: XCOLOR_SUBTITLE forState:UIControlStateNormal];
        address_Btn.titleLabel.font = XFONT(XFONT_SIZE(13));
        [address_Btn setImage:[UIImage imageNamed:@"Uni_anthor"]  forState:UIControlStateNormal];
        [self.contentView addSubview:address_Btn];
        self.addressBtn = address_Btn;
        [address_Btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        address_Btn.userInteractionEnabled = NO;
        
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
    
    
    [self.addressBtn setTitle:uniObj.address_long  forState:UIControlStateNormal];
    self.addressBtn.frame = uni_Frame.address_Frame;
    
    
    CGFloat addressWidth = [uniObj.address_long KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
     //判断地址字符串太长时，换一个短的地址
    if (addressWidth > (uni_Frame.address_Frame.size.width - 30)) {
        
        [self.addressBtn setTitle:uniObj.address_short forState:UIControlStateNormal];
     }
    
    self.rankBtn.frame = uni_Frame.rank_Frame;
    
    self.StarsBgView.hidden = !self.isStart;
    
    self.hotView.image = uni_Frame.universtiy.hot ? [UIImage imageNamed:GDLocalizedString(@"University-hot")]:[UIImage imageNamed:@""];
    
    //当排名方式是 世界排名时，只显示世界排名信息
    if ([self.optionOrderBy isEqualToString:RANK_QS]) {
        
        NSString   *rankStr01 = uniObj.ranking_qs.intValue == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"):[NSString stringWithFormat:@"%@",uniObj.ranking_qs];
        [self.rankBtn setTitle:[NSString stringWithFormat:@"世界排名：%@",rankStr01] forState:UIControlStateNormal];
        self.StarsBgView.hidden = YES;

        return;
    }
    
    //判断是否需要显示*号   澳大利来排名时
    if (self.isStart) {
        
        self.StarsBgView.frame = uni_Frame.starBgFrame;
        CGPoint center = self.StarsBgView.center;
        center.y = self.rankBtn.center.y;
        self.StarsBgView.center = center;
        [self.rankBtn setTitle:[NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")]  forState:UIControlStateNormal];
        NSInteger  StarCount  = uniObj.ranking_ti.integerValue;
        
        //暂无排名时

        if (StarCount == DEFAULT_NUMBER) {
            
            [self.rankBtn setTitle:@"本国排名：暂无排名" forState:UIControlStateNormal];
            
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
        [self.rankBtn setTitle:[NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01]  forState:UIControlStateNormal];
    }

}
 


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
