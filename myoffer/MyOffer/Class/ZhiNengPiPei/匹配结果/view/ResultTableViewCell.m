//
//  ResultTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ResultTableViewCell.h"
#import "UniversityFrame.h"
#import "MyOfferUniversityModel.h"

@interface ResultTableViewCell ()
@property(nonatomic,copy)NSString *universityID;
@property(nonatomic,strong)UIView *starBgView;
//中文名
@property (strong, nonatomic)  UILabel *nameLab;
//英文名
@property (strong, nonatomic)  UILabel *official_nameLab;
//排名
@property(nonatomic,strong)UIButton *rankBtn;
//logo图标
@property (strong, nonatomic)  LogoView *iconView;
//地理图标
//@property(nonatomic,strong)UIImageView *anchorView;
//地理位置
@property(nonatomic,strong)UIButton *address_Btn;

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

    //logo图标
    self.iconView =[[LogoView alloc] init];
    [self.contentView addSubview:self.iconView];
   
    //中文名
    self.nameLab =[self getLabelWithFontSize:XFONT_SIZE(17) andTextColor:XCOLOR_TITLE];
     
    //英文名
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

    
    //地理位置
    UIButton *address_Btn = [[UIButton alloc] init];
    [address_Btn setTitleColor: XCOLOR_SUBTITLE forState:UIControlStateNormal];
    address_Btn.titleLabel.font = XFONT(XFONT_SIZE(13));
    [address_Btn setImage:[UIImage imageNamed:@"Uni_anthor"]  forState:UIControlStateNormal];
    [self.contentView addSubview:address_Btn];
    self.address_Btn = address_Btn;
    [address_Btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    //存放星星View
    self.starBgView =[[UIView alloc] init];
    [self.contentView addSubview:self.starBgView];
    
    for (NSInteger i = 0; i<5; i++) {
        
        UIImageView *mv =[[UIImageView alloc] init];
        mv.image = [UIImage imageNamed:@"star"];
        mv.contentMode = UIViewContentModeScaleAspectFit;
        [self.starBgView addSubview:mv];
    }

     
    [self.selectButton addTarget:self action:@selector(selectCellID:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab =[[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font =[UIFont systemFontOfSize:fontSize];
    
    [self.contentView  addSubview:Lab];

    return Lab;
}


- (void)configureWithUniversityFrame:(UniversityFrame *)uniFrame {
    
    [self configureWithUniversityFrame:uniFrame ranking:RANK_TI];
}

- (void)configureWithUniversityFrame:(UniversityFrame *)uniFrame ranking:(NSString *)ranking {
   
    MyOfferUniversityModel *university =  uniFrame.university;
    
    self.universityID = university.NO_id;
    self.nameLab.frame = uniFrame.name_Frame;
    self.nameLab.text = university.name;
    
    self.official_nameLab.frame = uniFrame.official_Frame;
    self.official_nameLab.text = university.official_name;
    
 
    self.iconView.frame = uniFrame.icon_Frame;
    [self.iconView.logoImageView KD_setImageWithURL:university.logo];
    
    self.isStart = [university.country isEqualToString:GDLocalizedString(@"CategoryVC-AU")]?YES:NO;
    
    self.rankBtn.frame =uniFrame.rank_Frame;
    
    
    self.starBgView.hidden = !self.isStart;
    self.optionOrderBy =  @"ranking_ti";
    
    
//    self.anchorView.frame = uniFrame.anchorFrame;
    
    [self.address_Btn setTitle:university.address_short  forState:UIControlStateNormal];
    self.address_Btn.frame = uniFrame.address_Frame;
    
    
    BOOL RANK_TIType = [self.optionOrderBy isEqualToString:RANK_TI];
    
    if (!self.isStart) {
        
        if (RANK_TIType) {
            
            NSString   *rankStr01 = [university.ranking_ti intValue] == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"): [NSString stringWithFormat:@"%@",university.ranking_ti];
            NSString *rank = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
            [self.rankBtn setTitle:rank forState:UIControlStateNormal];
            
        }else{
            
            NSString   *rankStr02 = [university.ranking_qs intValue]  == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"):[NSString stringWithFormat:@"%@",university.ranking_qs];
             NSString *rank = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniversityDetail-003"), rankStr02];
            
            [self.rankBtn setTitle:rank forState:UIControlStateNormal];
        }
        
        
    }else{
        
        self.starBgView.frame = uniFrame.starBgFrame;
        
        [self.rankBtn setTitle:[NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")] forState:UIControlStateNormal];

        NSInteger  StarCount  = university.ranking_ti.integerValue;
        
        for (NSInteger i =0; i < self.starBgView.subviews.count; i++) {
            
            UIImageView *imageV = (UIImageView *)self.starBgView.subviews[i];
            
            imageV.frame = CGRectMake([uniFrame.starFrames[i] integerValue], 0, 15, 15);
        }
        for (NSInteger i =0; i < StarCount; i++) {
            
            UIImageView *mv = (UIImageView *)self.starBgView.subviews[i];
            
            mv.hidden = NO;
            
        }
        for (NSInteger i = StarCount ; i < self.starBgView.subviews.count; i++) {
            
            UIImageView *mv = (UIImageView *)self.starBgView.subviews[i];
            
            mv.hidden = YES;
        }
        
    }
    
}

- (void)configrationCellLefButtonWithTitle:(NSString  *)title imageName:(NSString *)imageName{

    [self.selectButton setTitle:title  forState:UIControlStateNormal];
    [self.selectButton setImage:XImage(imageName) forState:UIControlStateNormal];
}



- (void)selectCellID:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(selectResultTableViewCellItem:withUniversityInfo:)]) {
        
        [self.delegate selectResultTableViewCellItem:sender withUniversityInfo:self.universityID];
    }

}



@end
