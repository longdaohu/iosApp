//
//  NewSearchResultCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#import "UILabel+ResizeHelper.h"
#import "NewSearchResultCell.h"
#import "UniversityFrameObj.h"
#import "UniversityObj.h"

@interface NewSearchResultCell()
  //LOGO图片
@property(nonatomic,strong)LogoView *LogoMView;
@property(nonatomic,strong)UIImageView *hotView;
 //学校名称
@property(nonatomic,strong)UILabel *titleLabel;
//主要显示英文学校名称
@property(nonatomic,strong)UILabel *subTitleLabel;
 //地理位置
@property(nonatomic,strong)UILabel *rankLabel;
//地理图标
@property(nonatomic,strong)UIImageView *LocalMV;
//地理位置
@property(nonatomic,strong)UITextField *LocalTF;
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
        
        self.LogoMView =[[LogoView alloc] init];
        [self addSubview:self.LogoMView];
        
  
        self.titleLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYTITLEFONT) andTextColor:XCOLOR_BLACK];
        self.titleLabel.hidden = USER_EN ? YES : NO;
        
        CGFloat  subFontSize  = USER_EN ? KDUtilSize(UNIVERISITYTITLEFONT) : KDUtilSize(UNIVERISITYSUBTITLEFONT);
        self.subTitleLabel =[self getLabelWithFontSize:subFontSize  andTextColor:XCOLOR_BLACK];
        self.subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.subTitleLabel.numberOfLines = 2;
        self.subTitleLabel.clipsToBounds = YES;
 
        
        self.LocalMV  =[[UIImageView alloc] init];
        self.LocalMV.image = [UIImage imageNamed:@"Uni_anthor"];
        self.LocalMV.contentMode = UIViewContentModeScaleAspectFit;
        
        self.LocalTF = [[UITextField alloc] init];
        self.LocalTF.contentVerticalAlignment =UIControlContentVerticalAlignmentBottom;
        self.LocalTF.textColor = XCOLOR_DARKGRAY;
        self.LocalTF.font = FontWithSize(KDUtilSize(UNIVERISITYLOCALFONT));
        self.LocalTF.leftViewMode = UITextFieldViewModeAlways;
        self.LocalTF.userInteractionEnabled = NO;
        self.LocalTF.leftView = self.LocalMV;
        [self addSubview:self.LocalTF];
        
        self.rankLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYLOCALFONT)  andTextColor:XCOLOR_DARKGRAY];
        
        self.starBackground =[[UIView alloc] init];
        [self addSubview:self.starBackground];
        
        for (NSInteger i = 0; i<5; i++) {
            
            UIImageView *mv =[[UIImageView alloc] init];
            mv.image = [UIImage imageNamed:@"star"];
            mv.contentMode = UIViewContentModeScaleAspectFill;
            [self.starBackground addSubview:mv];
        }
        
        
        self.optionOrderBy =  RANKTI ;
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

-(void)setUni_Frame:(UniversityFrameObj *)uni_Frame
{
    _uni_Frame = uni_Frame;
    UniversityObj *uniObj = uni_Frame.uniObj;
    
    self.LogoMView.frame = uni_Frame.LogoFrame;
    [self.LogoMView.logoImageView KD_setImageWithURL:uniObj.logoName];
    
    self.titleLabel.frame = uni_Frame.TitleFrame;
    self.titleLabel.text = uniObj.titleName;
    
    self.subTitleLabel.text = uniObj.subTitleName;
    self.subTitleLabel.frame = uni_Frame.SubTitleFrame;
    
    self.LocalMV.frame = uni_Frame.LocalMVFrame;
    self.LocalTF.frame = uni_Frame.LocalFrame;
    self.LocalTF.text = uni_Frame.uniObj.LocalPlaceName;
    
    self.rankLabel.frame = uni_Frame.RankFrame;
    self.starBackground.hidden = !self.isStart;
    
    self.hotView.image = uni_Frame.uniObj.isHot ? [UIImage imageNamed:GDLocalizedString(@"University-hot")]:[UIImage imageNamed:@""];
    
    if (self.isStart) {
        
        self.starBackground.frame = uni_Frame.starBgFrame;
        CGPoint center = self.starBackground.center;
        center.y = self.rankLabel.center.y;
        self.starBackground.center = center;
        self.rankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        NSInteger  StarCount  = uniObj.RANKTIName.integerValue;
        
        
        if (StarCount == DefaultNumber) {
            
            NSString   *rankStr01 = uniObj.RANKTIName.intValue == DefaultNumber ? GDLocalizedString(@"SearchResult_noRank"):uniObj.RANKTIName;
           
            self.rankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
            self.starBackground.hidden = YES;
        
            return;
            
        }else{
        
            self.starBackground.hidden = NO;

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
        
        NSString   *rankStr01 = uniObj.RANKTIName.intValue == DefaultNumber ? GDLocalizedString(@"SearchResult_noRank"):uniObj.RANKTIName;
        self.rankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
  
    }
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
 
    
    CGFloat hotX = XScreenWidth - 50;
    CGFloat hotY = 0;
    CGFloat hotW = 50;
    CGFloat hotH = 50;
    self.hotView.frame = CGRectMake(hotX, hotY, hotW, hotH);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
