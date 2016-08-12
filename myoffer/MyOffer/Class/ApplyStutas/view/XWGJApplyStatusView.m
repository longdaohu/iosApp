//
//  ApplyStatusView.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJApplyStatusView.h"
#import "UILabel+ResizeHelper.h"
#import "UniversityObj.h"
#import "UniversityFrame.h"
#import "UniversityFrameObj.h"
@interface XWGJApplyStatusView()
 //LOGO图片
@property(nonatomic,strong)LogoView *LogoMView;
 //学校名称
@property(nonatomic,strong)UILabel *TitleLabel;
//主要显示英文学校名称
@property(nonatomic,strong)UILabel *SubTitleLabel;
//地理位置
@property(nonatomic,strong)UILabel *LocalLabel;
//排名
@property(nonatomic,strong)UILabel *RankLabel;
//用于显示 星号图标
@property(nonatomic,strong)UIView *StarBackground;
 //用于判断是否显示**图标
@property(nonatomic,assign)BOOL  flag;
@end

@implementation XWGJApplyStatusView



+(instancetype)CreateSectionViewWithTableView:(UITableView *)tableView
{
    static NSString *Identifier =@"identifier";
    
    XWGJApplyStatusView *sectionHeader =[tableView dequeueReusableHeaderFooterViewWithIdentifier:Identifier];
    if (!sectionHeader) {
        sectionHeader = [[XWGJApplyStatusView alloc] initWithReuseIdentifier:Identifier];
    }
    return sectionHeader;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.LogoMView =[[LogoView alloc] init];
        [self addSubview:self.LogoMView];
        
        self.TitleLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYTITLEFONT) andTextColor:XCOLOR_BLACK];
        [self addSubview:self.TitleLabel];
        self.TitleLabel.hidden = USER_EN ? YES : NO;
 
        CGFloat  subFontSize              = USER_EN? KDUtilSize(UNIVERISITYTITLEFONT) : KDUtilSize(UNIVERISITYSUBTITLEFONT);
        self.SubTitleLabel                = [self getLabelWithFontSize:subFontSize  andTextColor:XCOLOR_BLACK];
         self.SubTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.SubTitleLabel.numberOfLines  = 2;
        self.SubTitleLabel.clipsToBounds  = YES;
        [self addSubview:self.SubTitleLabel];
        
        self.LocalLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYLOCALFONT)   andTextColor:XCOLOR_DARKGRAY];
        [self addSubview:self.LocalLabel];
        
        
        self.RankLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYLOCALFONT)  andTextColor:XCOLOR_DARKGRAY];
        [self addSubview:self.RankLabel];
        
        self.StarBackground =[[UIView alloc] init];
        [self addSubview:self.StarBackground];
        
        for (NSInteger i = 0; i<5; i++) {
            UIImageView *mv = [[UIImageView alloc] init];
            mv.contentMode  = UIViewContentModeScaleAspectFit;
            mv.image        = [UIImage imageNamed:@"star"];
            [self.StarBackground addSubview:mv];
        }
        
        
        self.contentView.backgroundColor  = [UIColor whiteColor];
        
    }
    return self;
}

-(UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab  = [[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font      = [UIFont systemFontOfSize:fontSize];
    
    return Lab;
}


-(void)setUni_Frame:(UniversityFrameObj *)uni_Frame
{
    _uni_Frame = uni_Frame;
    UniversityObj *uniObj = uni_Frame.uniObj;
    
    [self.LogoMView.logoImageView KD_setImageWithURL:uniObj.logoName];
    self.LogoMView.frame  = uni_Frame.LogoFrame;

    self.TitleLabel.text  = uniObj.titleName;
    self.TitleLabel.frame = uni_Frame.TitleFrame;


    self.SubTitleLabel.text  = [[InternationalControl userLanguage] containsString:@"en"]?uniObj.titleName:uniObj.subTitleName;
    self.SubTitleLabel.frame = uni_Frame.SubTitleFrame;

    self.LocalLabel.text  = [NSString stringWithFormat:@"%@：%@- %@- %@",GDLocalizedString(@"UniversityDetail-005"),uniObj.countryName, uniObj.stateName,uniObj.cityName];
    self.LocalLabel.frame = uni_Frame.LocalFrame;

 
    //用于判断是否显示**图标
    self.flag = [uniObj.countryName isEqualToString:GDLocalizedString(@"CategoryVC-AU")];

    self.StarBackground.hidden = !self.flag;


    if (!self.flag) {

             NSString *rankStr01 = uniObj.RANKTIName.intValue == 99999?GDLocalizedString(@"SearchResult_noRank"):uniObj.RANKTIName;
             self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];

 
    }else{

        self.RankLabel.text       = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        self.StarBackground.frame = uni_Frame.starBgFrame;

        //用于防止数据异常太大出现冲突情况
        NSInteger StarCount =  uniObj.RANKTIName.integerValue > 5 ? 5 : uniObj.RANKTIName.integerValue;

        for (NSInteger i = 0; i < self.StarBackground.subviews.count; i++) {

            UIImageView *imageV = (UIImageView *)self.StarBackground.subviews[i];
            imageV.frame        = CGRectMake([uni_Frame.starFrames[i] integerValue], 0, 15, 15);
        }


        for (NSInteger i = 0; i < StarCount; i++) {

            UIImageView *mv = (UIImageView *)self.StarBackground.subviews[i];
            mv.hidden       = NO;

        }

        for (NSInteger i = StarCount ; i < self.StarBackground.subviews.count; i++) {

            UIImageView *mv = (UIImageView *)self.StarBackground.subviews[i];
            mv.hidden       = YES;
        }
 
        
    }
    self.RankLabel.frame = uni_Frame.RankFrame;
    

    
}


@end
