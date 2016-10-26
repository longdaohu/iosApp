//
//  ApplySectionHeaderView.m
//  myOffer
//
//  Created by sara on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#import "UILabel+ResizeHelper.h"
#import "ApplySectionHeaderView.h"
#import "UniversityFrameApplyObj.h"
#import "UniversityItemNew.h"


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

@property(nonatomic,strong) UITapGestureRecognizer *tap;

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
        self.nameLab =[self getLabelWithFontSize:XPERCENT * 15 andTextColor:XCOLOR_BLACK];
        
         //学校英文名
        self.official_nameLab =[self getLabelWithFontSize:XPERCENT * 11  andTextColor:XCOLOR_BLACK];
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
        self.address_detail_TF.font = FontWithSize(XPERCENT * 11);
        self.address_detail_TF.userInteractionEnabled = NO;
        [self.bgView addSubview:self.address_detail_TF];
        
        //排名
        self.RankLabel =[self getLabelWithFontSize:XPERCENT * 11  andTextColor:XCOLOR_DARKGRAY];
        
        
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
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        self.tap  = tap;
        [self.bgView addGestureRecognizer:tap];

    }
    
    return self;
}

-(UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab =[[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font =[UIFont systemFontOfSize:fontSize];
    [self.bgView addSubview:Lab];

    return Lab;
}






-(void)setUniFrame:(UniversityFrameApplyObj *)uniFrame
{
    _uniFrame = uniFrame;
    
    UniversityItemNew *university = uniFrame.uni;
    
  
    self.cancelBtn.frame = uniFrame.CancelButtonFrame;
    
    
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
   
    
    
    self.RankLabel.frame = uniFrame.RankFrame;
    
    
    
    self.StarBackgroud.frame = uniFrame.starBgFrame;

    if (self.isStart) {
        
        self.RankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        NSInteger  StarCount  = university.ranking_ti.integerValue;
       
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
             NSString   *rankStr01 = university.ranking_ti.intValue == 99999 ? GDLocalizedString(@"SearchResult_noRank"): [NSString stringWithFormat:@"%@",university.ranking_ti];
            self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
    }
    
    self.addSubjectBtn.frame = uniFrame.AddButtonFrame;
  
}


-(void)sectionViewButtonPressed:(UIButton *)sender
{
   
    if (sender.tag == 11) {
        
        NSString *imageName = self.isSelected ? @"check-icons":@"check-icons-yes";
       
        [self.cancelBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        self.isSelected = !self.isSelected ;
    }
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
        
    }
    
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    
    if (self.isEdit) {
        
        [self sectionViewButtonPressed:self.cancelBtn];
        
    }else{
        [self sectionViewButtonPressed:self.addSubjectBtn];

    }
    
}


-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    NSString *imageName = self.isSelected ? @"check-icons-yes":@"check-icons";
    [self.cancelBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}


-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}





-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.address_detail_TF.text) {
        CGFloat Leftx = 0;
        CGFloat Lefty = 0;
        CGFloat Lefth = CGRectGetHeight(self.RankLabel.frame);
        CGFloat Leftw = Lefth;
        UIImageView *item = (UIImageView *)self.anchorView.subviews.firstObject;
        item.frame = CGRectMake(Leftx,Lefty,Leftw, Lefth);
    }
    
    CGFloat SBx = self.isEdit ? 50 : 0;
    self.bgView.frame = CGRectMake(SBx,0, XScreenWidth, University_HEIGHT);
    
}




@end
