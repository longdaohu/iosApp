//
//  ResultTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ResultTableViewCell.h"
#import "UniversityObj.h"
#import "UniversityFrame.h"

@interface ResultTableViewCell ()
@property(nonatomic,copy)NSString *universityID;
@property(nonatomic,strong)UIView *starBackground;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *subTitleLabel;
@property (strong, nonatomic)  UILabel *rankLabel;
@property (strong, nonatomic)  LogoView *logoView;
//地理图标
@property(nonatomic,strong)UIView *LocalMV;
//地理位置
@property(nonatomic,strong)UITextField *LocalTF;

@end


@implementation ResultTableViewCell
+(instancetype)cellInitWithTableView:(UITableView *)tableView{

   static NSString  *identify = @"Result";
   ResultTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[NSBundle mainBundle] loadNibNamed:@"ResultTableViewCell" owner:nil options:nil].lastObject;
        
    }
    
    return cell;
}


- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.logoView =[[LogoView alloc] init];
    [self addSubview:self.logoView];
    
    self.titleLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYTITLEFONT) andTextColor:XCOLOR_BLACK];
    self.titleLabel.hidden = USER_EN ? YES : NO;
    
    CGFloat  subFontSize  = USER_EN? KDUtilSize(UNIVERISITYTITLEFONT) : KDUtilSize(UNIVERISITYSUBTITLEFONT);
    self.subTitleLabel =[self getLabelWithFontSize:subFontSize  andTextColor:XCOLOR_BLACK];
    self.subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.subTitleLabel.numberOfLines = 2;
    self.subTitleLabel.clipsToBounds = YES;
    
    self.rankLabel =[self getLabelWithFontSize:KDUtilSize(UNIVERISITYLOCALFONT)  andTextColor:XCOLOR_DARKGRAY];

    
    
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
    
    self.starBackground =[[UIView alloc] init];
    [self addSubview:self.starBackground];
    
    for (NSInteger i = 0; i<5; i++) {
        UIImageView *mv =[[UIImageView alloc] init];
        mv.image = [UIImage imageNamed:@"star"];
        mv.contentMode = UIViewContentModeScaleAspectFit;
        [self.starBackground addSubview:mv];
    }

    
    
    [self.selectButton addTarget:self action:@selector(selectCellID:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab =[[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font =[UIFont systemFontOfSize:fontSize];
    
    [self addSubview:Lab];

    return Lab;
}

- (void)configureWithInfo:(UniversityFrame *)info {
    
    [self configureWithInfo:info ranking:RANKTI];
}

- (void)configureWithInfo:(UniversityFrame *)uniFrame ranking:(NSString *)ranking {
   
    UniversityObj *university =  uniFrame.uniObj;
    
    self.universityID = university.universityID;
    self.titleLabel.frame = uniFrame.TitleFrame;
    self.titleLabel.text = university.titleName;
    
    self.subTitleLabel.frame = uniFrame.SubTitleFrame;
    self.subTitleLabel.text = university.subTitleName;
    
 
    self.logoView.frame = uniFrame.LogoFrame;
    [self.logoView.logoImageView KD_setImageWithURL:university.logoName];
    
    self.isStart = [university.countryName isEqualToString:GDLocalizedString(@"CategoryVC-AU")]?YES:NO;
    
    self.rankLabel.frame =uniFrame.RankFrame;
    
    
    self.starBackground.hidden = !self.isStart;
    self.optionOrderBy =  @"ranking_ti";
    
    
    self.LocalMV.frame = uniFrame.LocalMVFrame;
    
    self.LocalTF.text = [NSString stringWithFormat:@"%@-%@",university.countryName,university.cityName];
    self.LocalTF.frame = uniFrame.LocalFrame;
    
    
    BOOL RankTIType = [self.optionOrderBy isEqualToString:RANKTI];
    
    
    if (!self.isStart) {
        
        
        if (RankTIType) {
            NSString   *rankStr01 = [university.RANKTIName intValue] == 99999?GDLocalizedString(@"SearchResult_noRank"):university.RANKTIName;
            self.rankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
        }else{
            
            NSString   *rankStr02 = [university.RANKTIName intValue]  == 99999?GDLocalizedString(@"SearchResult_noRank"):university.RANKTIName;
            self.rankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniversityDetail-003"), rankStr02];
        }
    }else{
        
        self.starBackground.frame = uniFrame.starBgFrame;
        
        self.rankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        NSInteger  StarCount  = university.RANKTIName.integerValue;
        for (NSInteger i =0; i < self.starBackground.subviews.count; i++) {
            
            UIImageView *imageV = (UIImageView *)self.starBackground.subviews[i];
            
            imageV.frame = CGRectMake([uniFrame.starFrames[i] integerValue], 0, 15, 15);
        }
        for (NSInteger i =0; i < StarCount; i++) {
            
            UIImageView *mv = (UIImageView *)self.starBackground.subviews[i];
            
            mv.hidden = NO;
            
        }
        for (NSInteger i = StarCount ; i < self.starBackground.subviews.count; i++) {
            
            UIImageView *mv = (UIImageView *)self.starBackground.subviews[i];
            
            mv.hidden = YES;
        }
        
    }

    
    
}


-(void)selectCellID:(UIButton *)sender
{

    if ([self.delegate respondsToSelector:@selector(selectResultTableViewCellItem:withUniversityInfo:)]) {
        
        [self.delegate selectResultTableViewCellItem:sender withUniversityInfo:self.universityID];
    }

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.LocalTF.text) {
        CGFloat Leftx = 0;
        CGFloat Lefty = -1;
        CGFloat Lefth = CGRectGetHeight(self.rankLabel.frame);
        CGFloat Leftw = Lefth;
        UIImageView *item = (UIImageView *)self.LocalMV.subviews.firstObject;
        item.frame = CGRectMake(Leftx,Lefty,Leftw, Lefth);
    }
    
}


@end
