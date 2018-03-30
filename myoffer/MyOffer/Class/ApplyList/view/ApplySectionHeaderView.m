//
//  ApplySectionHeaderView.m
//  myOffer
//
//  Created by sara on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#import "ApplySectionHeaderView.h"
#import "UniversityFrameNew.h"
#import "MyOfferUniversityModel.h"


@interface ApplySectionHeaderView ()
 //LOGO图标
@property(nonatomic,strong)LogoView *iconView;
 //学校名称
@property(strong,nonatomic) UILabel *nameLab;
 //学校英文名
@property(strong,nonatomic) UILabel *official_nameLab;
//地理图标
@property(nonatomic,strong)UIImageView *anchorView;
//地理位置
@property(nonatomic,strong)UIButton *addressBtn;
//排名图标
@property(nonatomic,strong)UIImageView *rankIconView;
 //排名
@property(nonatomic,strong) UIButton *rankBtn;
 //添加专业按钮
@property(nonatomic,strong) UIButton *addSubjectBtn;
 //删除按钮
@property(nonatomic,strong) UIButton *cancelBtn;
//背景View
@property(nonatomic,strong) UIView *bgView;
//**号背景
@property(nonatomic,strong) UIView *StarsBgView;
//底部分隔线
@property(nonatomic,strong) UIView *bottom_line;

@property(nonatomic,strong)UIImageView *hot;


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
         self.iconView =[[LogoView alloc] init];
        [self.bgView addSubview:self.iconView];
    
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
        [self.bgView addSubview:rankBtn];
        self.rankBtn = rankBtn;
        [rankBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        rankBtn.userInteractionEnabled = NO;

        
        //地理位置
        UIButton *address_Btn = [[UIButton alloc] init];
        [address_Btn setTitleColor: XCOLOR_SUBTITLE forState:UIControlStateNormal];
        address_Btn.titleLabel.font = XFONT(XFONT_SIZE(13));
        [address_Btn setImage:[UIImage imageNamed:@"Uni_anthor"]  forState:UIControlStateNormal];
        [self.bgView addSubview:address_Btn];
        self.addressBtn = address_Btn;
        [address_Btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        address_Btn.userInteractionEnabled = NO;

         
        
        //底部分隔线
        UIView *line = [UIView new];
        line.hidden = YES;
        line.backgroundColor = XCOLOR_line;
        [self.bgView addSubview:line];
        self.bottom_line = line;
        
        //**号背景
        self.StarsBgView =[[UIView alloc] init];
        self.StarsBgView.backgroundColor = XCOLOR_WHITE;
        [self.contentView addSubview:self.StarsBgView];
        
        for (NSInteger i = 0; i < 5; i++) {
            UIImageView *mv =[[UIImageView alloc] init];
            mv.image = [UIImage imageNamed:@"star"];
            mv.contentMode = UIViewContentModeScaleAspectFit;
            [self.StarsBgView addSubview:mv];
        }
        
         //添加专业按钮
        self.addSubjectBtn =[[UIButton alloc] init];
        [self.addSubjectBtn setImage:[UIImage imageNamed:@"add_cross"] forState:UIControlStateNormal];
        self.addSubjectBtn.tag = 10;
        [self.addSubjectBtn addTarget:self action:@selector(sectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.addSubjectBtn];
        
        self.contentView.backgroundColor =[UIColor whiteColor];
        
        
        UIImageView *hot =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_cn"]];
        hot.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:hot];
        self.hot = hot;
        
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
    
    MyOfferUniversityModel *university = uniFrame.universtiy;
    
  
    self.cancelBtn.frame = uniFrame.cancel_Frame;
    self.addSubjectBtn.frame = uniFrame.add_Frame;

    
    self.isStart = [university.country isEqualToString:GDLocalizedString(@"CategoryVC-AU")]?YES:NO;
    self.StarsBgView.hidden = !self.isStart;
    
    
   [self.iconView.logoImageView KD_setImageWithURL:university.logo];
    self.iconView.frame = uniFrame.icon_Frame;
    
    
    self.nameLab.text = university.name;
    self.nameLab.frame = uniFrame.name_Frame;
    
    
    self.official_nameLab.text = university.official_name;
    self.official_nameLab.frame = uniFrame.official_Frame;
    

    [self.addressBtn setTitle:university.address_long  forState:UIControlStateNormal];
    self.addressBtn.frame = uniFrame.address_Frame;
    
    
    CGFloat addressWidth = [university.address_long KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)].width;
    //判断地址字符串太长时，换一个短的地址
    if (addressWidth > (uniFrame.address_Frame.size.width - 30)) {
        
        [self.addressBtn setTitle:university.address_short  forState:UIControlStateNormal];
    }
    
  
    self.rankBtn.frame = uniFrame.rank_Frame;
    
    self.hot.frame = uniFrame.hot_Frame;
    
    self.bottom_line.frame =  uniFrame.bottom_line_Frame;
    
    
    self.StarsBgView.frame = uniFrame.starBgFrame;
    
    //当排名方式是 世界排名时，只显示世界排名信息
    if ([self.optionOrderBy isEqualToString:RANK_QS]) {
        
        NSString   *rankStr01 = university.ranking_qs.intValue == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"): [NSString stringWithFormat:@"%@",university.ranking_qs];
        
        [self.rankBtn setTitle:[NSString stringWithFormat:@"世界排名：%@",rankStr01] forState:UIControlStateNormal];
        
        self.StarsBgView.hidden = YES;
        
        return;
    }
    
    
    //判断是否需要显示*号   澳大利来排名时
    if (self.isStart) {
        
        [self.rankBtn setTitle:[NSString stringWithFormat:@"%@：暂无排名",GDLocalizedString(@"SearchRank_Country")] forState:UIControlStateNormal];
        
        for (NSInteger i =0; i < self.StarsBgView.subviews.count; i++) {
            
            UIView *starView = self.StarsBgView.subviews[i];
            NSString *star_frame_str  = uniFrame.star_frames[i];
            starView.frame = CGRectFromString(star_frame_str);
        }

        
    }else{
           //英国排名
            NSString   *rankStr01 = university.ranking_ti.intValue == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"): [NSString stringWithFormat:@"%@",university.ranking_ti];
           [self.rankBtn setTitle:[NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01]   forState:UIControlStateNormal];
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

-(void)showUniveristy:(UITapGestureRecognizer *)tap{
    
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

- (void)addButtonWithHiden:(BOOL)hiden{

    self.addSubjectBtn.hidden = hiden;
}


- (void)showBottomLineHiden:(BOOL)hiden{

    self.bottom_line.hidden = hiden;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
 
    CGFloat SBx = self.isEdit ? 50 : 0;
    
    CGSize contentSize = self.bounds.size;
    
//    if (!self.cell_Animation) {
    
    self.bgView.frame = CGRectMake(SBx,0, contentSize.width, contentSize.height);
      
//        return;
//    }
 
//    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
//    
//        self.bgView.frame = CGRectMake(SBx,0, contentSize.width, contentSize.height);
//        
//    }];
    
    
}




@end
