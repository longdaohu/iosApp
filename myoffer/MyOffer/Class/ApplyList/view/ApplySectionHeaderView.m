//
//  ApplySectionHeaderView.m
//  myOffer
//
//  Created by sara on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#import "ApplySectionHeaderView.h"
#import "UniversityFrameNew.h"
#import "UniversityNew.h"


@interface ApplySectionHeaderView ()
 //LOGO图标
@property(nonatomic,strong)LogoView *LogoImageView;
 //学校名称
@property(strong,nonatomic) UILabel *nameLab;
 //学校英文名
@property(strong,nonatomic) UILabel *official_nameLab;
//地理图标
@property(nonatomic,strong)UIImageView *anchorView;
//地理位置
@property(nonatomic,strong)UITextField *address_detail_TF;
 //排名
@property(nonatomic,strong) UILabel *RankLabel;
 //添加专业按钮
@property(nonatomic,strong) UIButton *addSubjectBtn;
 //删除按钮
@property(nonatomic,strong) UIButton *cancelBtn;
//背景View
@property(nonatomic,strong) UIView *bgView;
//**号背景
@property(nonatomic,strong) UIView *StarBackgroud;


@end


@implementation ApplySectionHeaderView

+(instancetype)sectionHeaderViewWithTableView:(UITableView *)tableView{

    static NSString *identifier =@"ApplySectionHeader";

    ApplySectionHeaderView *sectionView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (!sectionView) {
        
        sectionView = [[ApplySectionHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return sectionView;
}


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        //删除按钮
        self.cancelBtn = [[UIButton alloc] init];
        [self.cancelBtn setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
        [self.cancelBtn setImage:[UIImage imageNamed:@"check-icons-yes"] forState:UIControlStateSelected];
        self.cancelBtn.tag = 11;
        [self.cancelBtn addTarget:self action:@selector(sectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelBtn];
        
        //背景View
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = XCOLOR_WHITE;
        [self.contentView addSubview: self.bgView];
        
        //LOGO图标
         self.LogoImageView =[[LogoView alloc] init];
        [self.bgView addSubview:self.LogoImageView];
    
        //学校名称
        self.nameLab =[self getLabelWithFontSize:Uni_title_FontSize andTextColor:XCOLOR_BLACK];
        
        //学校英文名
        self.official_nameLab =[self getLabelWithFontSize:Uni_subtitle_FontSize  andTextColor:XCOLOR_BLACK];
        self.official_nameLab.lineBreakMode = NSLineBreakByWordWrapping;
        self.official_nameLab.numberOfLines = 2;
        self.official_nameLab.clipsToBounds = YES;
        
        //地理图标
        self.anchorView =[[UIImageView alloc] init];
        self.anchorView.image = [UIImage imageNamed:@"Uni_anthor"];
        self.anchorView.contentMode = UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:self.anchorView];
        
        //地理位置
        self.address_detail_TF = [[UITextField alloc] init];
        self.address_detail_TF.textColor = XCOLOR_DARKGRAY;
        self.address_detail_TF.font = FontWithSize(Uni_address_FontSize);
        self.address_detail_TF.userInteractionEnabled = NO;
        [self.bgView addSubview:self.address_detail_TF];
        
        //排名
        self.RankLabel =[self getLabelWithFontSize:Uni_rank_FontSize  andTextColor:XCOLOR_DARKGRAY];
        
        
        //**号背景
        self.StarBackgroud =[[UIView alloc] init];
        [self.bgView addSubview:self.StarBackgroud];
        
        for (NSInteger i = 0; i<5; i++) {
            UIImageView *mv =[[UIImageView alloc] init];
            mv.image = [UIImage imageNamed:@"star"];
            mv.contentMode = UIViewContentModeScaleAspectFit;
            [self.StarBackgroud addSubview:mv];
        }
        
         //添加专业按钮
        self.addSubjectBtn =[[UIButton alloc] init];
        [self.addSubjectBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        self.addSubjectBtn.tag = 10;
        [self.addSubjectBtn addTarget:self action:@selector(sectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.addSubjectBtn];
        
        self.contentView.backgroundColor =[UIColor whiteColor];
        
        //监听页面点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUniveristy:)];
        [self.bgView addGestureRecognizer:tap];

    }
    
    return self;
}

//label创建共有方法
-(UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab =[[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font =[UIFont systemFontOfSize:fontSize];
    [self.bgView addSubview:Lab];

    return Lab;
}



-(void)setUniFrame:(UniversityFrameNew *)uniFrame
{
    _uniFrame = uniFrame;
    
    UniversityNew *university = uniFrame.universtiy;
    
  
    self.cancelBtn.frame = uniFrame.CancelButtonFrame;
    self.addSubjectBtn.frame = uniFrame.AddButtonFrame;

    
    self.isStart = [university.country isEqualToString:GDLocalizedString(@"CategoryVC-AU")]?YES:NO;
    self.StarBackgroud.hidden = !self.isStart;
    
    
   [self.LogoImageView.logoImageView KD_setImageWithURL:university.logo];
    self.LogoImageView.frame = uniFrame.LogoFrame;
    
    
    self.nameLab.text = university.name;
    self.nameLab.frame = uniFrame.nameFrame;
    
    
    self.official_nameLab.text = university.official_name;
    self.official_nameLab.frame = uniFrame.official_nameFrame;
    
    
    self.anchorView.frame = uniFrame.anchorFrame;
    self.address_detail_TF.frame = uniFrame.address_detailFrame;
    self.address_detail_TF.text = university.address_detail;
   
    CGFloat addressWidth = [university.address_detail KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
    //判断地址字符串太长时，换一个短的地址
    if (addressWidth > (uniFrame.address_detailFrame.size.width - 30)) {
        
         self.address_detail_TF.text = university.address_short;
        
    }
    
    self.RankLabel.frame = uniFrame.RankFrame;
    
    
    self.StarBackgroud.frame = uniFrame.starBgFrame;
    
    //当排名方式是 世界排名时，只显示世界排名信息
    if ([self.optionOrderBy isEqualToString:RANKQS]) {
        
        NSString   *rankStr01 = university.ranking_qs.intValue == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"): [NSString stringWithFormat:@"%@",university.ranking_qs];
        self.RankLabel.text = [NSString stringWithFormat:@"世界排名：%@",rankStr01];
        
        self.StarBackgroud.hidden = YES;
        
        return;
    }
    
    
    //判断是否需要显示*号   澳大利来排名时
    if (self.isStart) {
        
        self.RankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        NSInteger  StarCount  = university.ranking_ti.integerValue;
       
        //暂无排名时
        if (StarCount == DEFAULT_NUMBER) {
            
             self.RankLabel.text = @"本国排名：暂无排名";

            return;
        }
        
        
        for (NSInteger i =0; i < self.StarBackgroud.subviews.count; i++) {
            
            UIImageView *imageV = (UIImageView *)self.StarBackgroud.subviews[i];
            
            imageV.frame = CGRectMake([uniFrame.starFrames[i] integerValue], 0, 15, 15);
        }
        
        
        for (NSInteger i =0; i < StarCount; i++) {
            
            UIImageView *mv = (UIImageView *)self.StarBackgroud.subviews[i];
            
            mv.hidden = NO;
            
        }
        
        for (NSInteger i = StarCount ; i < self.StarBackgroud.subviews.count; i++) {
            
            UIImageView *mv = (UIImageView *)self.StarBackgroud.subviews[i];
            
            mv.hidden = YES;
        }
        
        
    }else{
           //英国排名
            NSString   *rankStr01 = university.ranking_ti.intValue == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"): [NSString stringWithFormat:@"%@",university.ranking_ti];
            self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
    }
    
    
  
}


-(void)sectionViewButtonPressed:(UIButton *)sender
{
   
    if (sender == self.cancelBtn) self.cancelBtn.selected = !self.cancelBtn.selected;
    
    //申请意向页面
    if (self.actionBlock) self.actionBlock(sender);
    
    //用于搜索结果页面
    if (self.newActionBlock)  self.newActionBlock(self.uniFrame.universtiy.NO_id);
}

-(void)showUniveristy:(UITapGestureRecognizer *)tap
{
    
    self.isEdit ?  [self sectionViewButtonPressed:self.cancelBtn]  :  [self sectionViewButtonPressed:self.addSubjectBtn];
    
}


-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    self.cancelBtn.selected = isSelected;

}


-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}


-(void)addButtonHiden
{
    self.addSubjectBtn.hidden = YES;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
 
    CGFloat SBx = self.isEdit ? 50 : 0;
    
    if (!self.cell_Animation) {
        
        self.bgView.frame = CGRectMake(SBx,0, XScreenWidth, Uni_Cell_Height);
      
        return;
    }
 
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.bgView.frame = CGRectMake(SBx,0, XScreenWidth, Uni_Cell_Height);
        
    }];
}




@end
