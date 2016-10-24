//
//  XSearchSectionHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XSearchSectionHeaderView.h"

@interface XSearchSectionHeaderView ()
//LOGO图片
@property(nonatomic,strong)LogoView *LogoMView;
//学校名称
@property(nonatomic,strong)UILabel *TitleLabel;
//主要显示英文学校名称
@property(nonatomic,strong)UILabel *SubTitleLabel;
//地理图标
@property(nonatomic,strong)UIView *LocalMV;
//地理位置
@property(nonatomic,strong)UITextField *LocalTF;
//排名
@property(nonatomic,strong)UILabel *RankLabel;
//用于显示 星号图标
@property(nonatomic,strong)UIView *StarBackground;
@property(nonatomic,copy)NSString *imageName;


@end

@implementation XSearchSectionHeaderView

+(instancetype)SectionHeaderViewWithTableView:(UITableView *)tableView
{
    static NSString *identifier =@"sectionHead";
    
    XSearchSectionHeaderView *sectionHeader =[tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (!sectionHeader) {
        sectionHeader = [[XSearchSectionHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    
    return sectionHeader;
}


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.LogoMView =[[LogoView alloc] init];
        [self.contentView addSubview:self.LogoMView];
        
        self.TitleLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYTITLEFONT) andTextColor:XCOLOR_BLACK];
        self.TitleLabel.hidden = USER_EN ? YES : NO;
        
        CGFloat  subFontSize  = USER_EN? KDUtilSize(UNIVERISITYTITLEFONT) : KDUtilSize(UNIVERISITYSUBTITLEFONT);
        self.SubTitleLabel =[self getLabelWithFontSize:subFontSize  andTextColor:XCOLOR_BLACK];
        self.SubTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.SubTitleLabel.numberOfLines = 2;
        self.SubTitleLabel.clipsToBounds = YES;
        
        
        self.LocalMV =[[UIView alloc] init];
        UIImageView *left =[[UIImageView alloc] init];
        left.image = [UIImage imageNamed:@"Uni_anthor"];
        left.contentMode = UIViewContentModeScaleAspectFit;
        [self.LocalMV addSubview:left];
        
        self.LocalTF = [[UITextField alloc] init];
        self.LocalTF.textColor = XCOLOR_DARKGRAY;
        self.LocalTF.font = FontWithSize(KDUtilSize(UNIVERISITYLOCALFONT));
        self.LocalTF.leftViewMode = UITextFieldViewModeAlways;
        self.LocalTF.userInteractionEnabled = NO;
        self.LocalTF.leftView = self.LocalMV;
        [self addSubview:self.LocalTF];
        
        self.RankLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYLOCALFONT)  andTextColor:XCOLOR_DARKGRAY];
        
 
        self.RecommendMV =[[UIImageView alloc] init];
        self.RecommendMV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.RecommendMV];
        
 
        
        self.StarBackground =[[UIView alloc] init];
         [self addSubview:self.StarBackground];
        
        for (NSInteger i = 0; i<5; i++) {
            UIImageView *mv =[[UIImageView alloc] init];
            mv.image = [UIImage imageNamed:@"star"];
            mv.contentMode = UIViewContentModeScaleAspectFit;
            [self.StarBackground addSubview:mv];
        }

        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroudView:)];
        [self addGestureRecognizer:tap];
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

-(NSString *)imageName
{
    if (!_imageName) {
         
        _imageName =  USER_EN? @"hot_en":@"hot_cn";
    }
    return _imageName;
}


-(void)setRANKTYPE:(NSString *)RANKTYPE
{
    _RANKTYPE = RANKTYPE;
    
}




-(void)setUni_Frame:(UniversityFrameObj *)uni_Frame
{
    _uni_Frame = uni_Frame;
 
    
    UniversityObj *uniObj = uni_Frame.uniObj;
    
    self.RecommendMV.image = uniObj.isHot ?[UIImage imageNamed:self.imageName] : [UIImage imageNamed:@""];
    self.RecommendMV.frame = uni_Frame.RecomandFrame;
    
    self.LogoMView.frame = uni_Frame.LogoFrame;
    [self.LogoMView.logoImageView KD_setImageWithURL:uniObj.logoName];

    self.TitleLabel.frame = uni_Frame.TitleFrame;
    self.TitleLabel.text = uniObj.titleName;
    
    self.SubTitleLabel.text = uniObj.subTitleName;
    self.SubTitleLabel.frame = uni_Frame.SubTitleFrame;

    self.LocalMV.frame = uni_Frame.LocalMVFrame;
    self.LocalTF.frame = uni_Frame.LocalFrame;
    self.LocalTF.text = uni_Frame.uniObj.LocalPlaceName;
    
    self.RankLabel.frame = uni_Frame.RankFrame;
    self.StarBackground.hidden = !self.IsStar;
    
    if (self.IsStar) {

        self.StarBackground.frame = uni_Frame.starBgFrame;
        self.RankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        NSInteger  StarCount  = uniObj.RANKTIName.integerValue;
        
        
        if (StarCount == DefaultNumber) {
            
            NSString   *rankStr01 = uniObj.RANKTIName.intValue == 99999?GDLocalizedString(@"SearchResult_noRank"):uniObj.RANKTIName;
            self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            self.StarBackground.hidden = YES;
            
            return;
            
        }else{
            
            self.StarBackground.hidden = NO;
            
        }
        
        for (NSInteger i =0; i < self.StarBackground.subviews.count; i++) {
        
            UIImageView *imageV = (UIImageView *)self.StarBackground.subviews[i];
        
            imageV.frame = CGRectMake([uni_Frame.starFrames[i] integerValue], 0, 15, 15);
        }
        for (NSInteger i =0; i < StarCount; i++) {
        
            UIImageView *mv = (UIImageView *)self.StarBackground.subviews[i];
        
            mv.hidden = NO;
            
        }
        for (NSInteger i = StarCount ; i < self.StarBackground.subviews.count; i++) {
        
            UIImageView *mv = (UIImageView *)self.StarBackground.subviews[i];
        
            mv.hidden = YES;
        }
        
        
    }else{
        
       
        if ([self.RANKTYPE isEqualToString:RANKTI]) {
            
            NSString   *rankStr01 = uniObj.RANKTIName.intValue == 99999?GDLocalizedString(@"SearchResult_noRank"):uniObj.RANKTIName;
            self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
        }else{
            NSString   *rankStr02 = uniObj.rankName.intValue == 99999?GDLocalizedString(@"SearchResult_noRank"):uniObj.rankName;
            self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_World"), rankStr02];
        }
     }
    
}


-(void)tapBackgroudView:(UITapGestureRecognizer *)tap
{
    if (self.actionBlock) {
        
        self.actionBlock(self.uni_Frame.uniObj.universityID);
    }
    
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
    
}


@end
