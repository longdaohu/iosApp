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
#import "UniversityObj.h"


@interface ApplySectionHeaderView ()
 //LOGO图标
@property(nonatomic,strong)LogoView *LogoImageView;
 //学校名称
@property(strong,nonatomic) UILabel *TitleLabel;
 //学校英文名
@property(strong,nonatomic) UILabel *SubTitleLabel;
//地理图标
@property(nonatomic,strong)UIView *LocalMV;
//地理位置
@property(nonatomic,strong)UITextField *LocalTF;
 //排名
@property(nonatomic,strong) UILabel *RankLabel;
 //添加专业按钮
@property(nonatomic,strong) UIButton *AddButton;
 //删除按钮
@property(nonatomic,strong) UIButton *CancelButton;
//背景View
@property(nonatomic,strong) UIView *SectionBackgroud;
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
        
        self.CancelButton = [[UIButton alloc] init];
        [self.CancelButton setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
//        self.CancelButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
        self.CancelButton.tag = 11;
        [self.CancelButton addTarget:self action:@selector(sectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.CancelButton];
        
        self.SectionBackgroud =[[UIView alloc] init];
        self.SectionBackgroud.backgroundColor = XCOLOR_WHITE;
        [self.contentView addSubview: self.SectionBackgroud];
        
         self.LogoImageView =[[LogoView alloc] init];
        [self.SectionBackgroud addSubview:self.LogoImageView];
    
        
        self.TitleLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYTITLEFONT) andTextColor:XCOLOR_BLACK];
        self.TitleLabel.hidden = USER_EN ? YES : NO;
        
        CGFloat  subFontSize  = USER_EN ? KDUtilSize(UNIVERISITYTITLEFONT) : KDUtilSize(UNIVERISITYSUBTITLEFONT);
        self.SubTitleLabel =[self getLabelWithFontSize:subFontSize  andTextColor:XCOLOR_BLACK];
        self.SubTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.SubTitleLabel.numberOfLines = 2;
        self.SubTitleLabel.clipsToBounds = YES;
        

        self.LocalMV =[[UIView alloc] init];
        UIImageView *left =[[UIImageView alloc] init];
        left.image = [UIImage imageNamed:@"anchor"];
        left.contentMode = UIViewContentModeScaleAspectFit;
        [self.LocalMV addSubview:left];
        
        self.LocalTF = [[UITextField alloc] init];
        self.LocalTF.textColor = XCOLOR_DARKGRAY;
        self.LocalTF.font = FontWithSize(KDUtilSize(UNIVERISITYLOCALFONT));
        self.LocalTF.leftViewMode = UITextFieldViewModeAlways;
        self.LocalTF.userInteractionEnabled = NO;
        self.LocalTF.leftView = self.LocalMV;
        [self.SectionBackgroud addSubview:self.LocalTF];
        

        self.RankLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYLOCALFONT)  andTextColor:XCOLOR_DARKGRAY];
        
        
        self.StarBackgroud =[[UIView alloc] init];
        [self.SectionBackgroud addSubview:self.StarBackgroud];
        
        for (NSInteger i = 0; i<5; i++) {
            UIImageView *mv =[[UIImageView alloc] init];
            mv.image = [UIImage imageNamed:@"star"];
            mv.contentMode = UIViewContentModeScaleAspectFit;
            [self.StarBackgroud addSubview:mv];
        }
        
        self.AddButton =[[UIButton alloc] init];
        [self.AddButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        self.AddButton.tag = 10;
        [self.AddButton addTarget:self action:@selector(sectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.SectionBackgroud addSubview:self.AddButton];
        
        self.contentView.backgroundColor =[UIColor whiteColor];
        
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        self.tap  = tap;
        [self.SectionBackgroud addGestureRecognizer:tap];

    }
    
    return self;
}

-(UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab =[[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font =[UIFont systemFontOfSize:fontSize];
    [self.SectionBackgroud addSubview:Lab];

    return Lab;
}






-(void)setUniFrame:(UniversityFrameApplyObj *)uniFrame
{
    _uniFrame = uniFrame;
    
    UniversityObj *university = uniFrame.uniObj;
    
    self.CancelButton.frame = uniFrame.CancelButtonFrame;
    
    
    self.isStart = [university.countryName isEqualToString:GDLocalizedString(@"CategoryVC-AU")]?YES:NO;
    self.StarBackgroud.hidden = !self.isStart;
    
    
   [self.LogoImageView.logoImageView KD_setImageWithURL:university.logoName];
    self.LogoImageView.frame = uniFrame.LogoFrame;
    
    self.TitleLabel.text = university.titleName;
    self.TitleLabel.frame = uniFrame.TitleFrame;
    
    self.SubTitleLabel.text = university.subTitleName;
    self.SubTitleLabel.frame = uniFrame.SubTitleFrame;
    
    
    self.LocalMV.frame = uniFrame.LocalMVFrame;
    self.LocalTF.frame = uniFrame.LocalFrame;
    self.LocalTF.text = [NSString stringWithFormat:@"%@-%@",university.countryName,university.cityName];
   
    self.RankLabel.frame = uniFrame.RankFrame;
    
    self.StarBackgroud.frame = uniFrame.starBgFrame;

    if (self.isStart) {
        
        self.RankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        NSInteger  StarCount  = university.RANKTIName.integerValue;
       
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
             NSString   *rankStr01 = university.RANKTIName.intValue == 99999?GDLocalizedString(@"SearchResult_noRank"):university.RANKTIName;
            self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
    }
    
    self.AddButton.frame = uniFrame.AddButtonFrame;
    
}


-(void)sectionViewButtonPressed:(UIButton *)sender
{
   
    if (sender.tag == 11) {
        
        NSString *imageName = self.isSelected ? @"check-icons":@"check-icons-yes";
       
        [self.CancelButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        self.isSelected = !self.isSelected ;
    }
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
        
    }
    
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    
    if (self.isEdit) {
        [self sectionViewButtonPressed:self.CancelButton];
        
    }else{
        [self sectionViewButtonPressed:self.AddButton];

    }
    
}


-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    NSString *imageName = self.isSelected ? @"check-icons-yes":@"check-icons";
    [self.CancelButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}


-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}





-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.LocalTF.text) {
        CGFloat Leftx = 0;
        CGFloat Lefty = 0;
        CGFloat Lefth = CGRectGetHeight(self.RankLabel.frame);
        CGFloat Leftw = Lefth;
        UIImageView *item = (UIImageView *)self.LocalMV.subviews.firstObject;
        item.frame = CGRectMake(Leftx,Lefty,Leftw, Lefth);
    }
    
    CGFloat SBx = self.isEdit ? 50 : 0;
    self.SectionBackgroud.frame = CGRectMake(SBx,0, XScreenWidth, University_HEIGHT);
    
}




@end
