//
//  ResultTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ResultTableViewCell.h"
#import "UniversityFrame.h"
#import "UniversityNew.h"

@interface ResultTableViewCell ()
@property(nonatomic,copy)NSString *universityID;
@property(nonatomic,strong)UIView *starBackground;
//中文名
@property (strong, nonatomic)  UILabel *nameLab;
//英文名
@property (strong, nonatomic)  UILabel *official_nameLab;
//排名
@property (strong, nonatomic)  UILabel *rankLab;
//logo图标
@property (strong, nonatomic)  LogoView *logoView;
//地理图标
@property(nonatomic,strong)UIImageView *anchorView;
//地理位置
@property(nonatomic,strong)UITextField *address_detail_TF;

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
    self.logoView =[[LogoView alloc] init];
    [self addSubview:self.logoView];
   
    //中文名
    self.nameLab =[self getLabelWithFontSize:Uni_title_FontSize andTextColor:XCOLOR_BLACK];
     
    //英文名
    self.official_nameLab =[self getLabelWithFontSize:Uni_subtitle_FontSize  andTextColor:XCOLOR_BLACK];
    self.official_nameLab.lineBreakMode = NSLineBreakByWordWrapping;
    self.official_nameLab.numberOfLines = 2;
    self.official_nameLab.clipsToBounds = YES;
    
    //排名
    self.rankLab =[self getLabelWithFontSize:Uni_rank_FontSize  andTextColor:XCOLOR_DARKGRAY];
 
    //地理图标
    self.anchorView =[[UIImageView alloc] init];
    self.anchorView.image = [UIImage imageNamed:@"Uni_anthor"];
    self.anchorView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.anchorView];
    
    //地理位置
    self.address_detail_TF = [[UITextField alloc] init];
    self.address_detail_TF.textColor = XCOLOR_DARKGRAY;
    self.address_detail_TF.font = FontWithSize(Uni_address_FontSize);
    self.address_detail_TF.userInteractionEnabled = NO;
    [self.contentView addSubview:self.address_detail_TF];
    
    //存放星星View
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


- (void)configureWithUniversityFrame:(UniversityFrame *)uniFrame {
    
    [self configureWithUniversityFrame:uniFrame ranking:RANKTI];
}

- (void)configureWithUniversityFrame:(UniversityFrame *)uniFrame ranking:(NSString *)ranking {
   
    UniversityNew *university =  uniFrame.university;
    
    self.universityID = university.NO_id;
    self.nameLab.frame = uniFrame.nameFrame;
    self.nameLab.text = university.name;
    
    self.official_nameLab.frame = uniFrame.official_nameFrame;
    self.official_nameLab.text = university.official_name;
    
 
    self.logoView.frame = uniFrame.LogoFrame;
    [self.logoView.logoImageView KD_setImageWithURL:university.logo];
    
    self.isStart = [university.country isEqualToString:GDLocalizedString(@"CategoryVC-AU")]?YES:NO;
    
    self.rankLab.frame =uniFrame.RankFrame;
    
    
    self.starBackground.hidden = !self.isStart;
    self.optionOrderBy =  @"ranking_ti";
    
    
    self.anchorView.frame = uniFrame.anchorFrame;
    
    self.address_detail_TF.text = university.address_short;
    self.address_detail_TF.frame = uniFrame.address_detailFrame;
    
    
    BOOL RankTIType = [self.optionOrderBy isEqualToString:RANKTI];
    
    if (!self.isStart) {
        
        if (RankTIType) {
            
            NSString   *rankStr01 = [university.ranking_ti intValue] == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"): [NSString stringWithFormat:@"%@",university.ranking_ti];
            self.rankLab.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
        }else{
            
            NSString   *rankStr02 = [university.ranking_qs intValue]  == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"):[NSString stringWithFormat:@"%@",university.ranking_qs];
            self.rankLab.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniversityDetail-003"), rankStr02];
        }
        
        
    }else{
        
        self.starBackground.frame = uniFrame.starBgFrame;
        
        self.rankLab.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        NSInteger  StarCount  = university.ranking_ti.integerValue;
        
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

- (void)configrationCellLefButtonWithTitle:(NSString  *)title imageName:(NSString *)imageName{

    [self.selectButton setTitle:title  forState:UIControlStateNormal];
    [self.selectButton setImage:XImage(imageName) forState:UIControlStateNormal];
}



- (void)selectCellID:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(selectResultTableViewCellItem:withUniversityInfo:)]) {
        
        [self.delegate selectResultTableViewCellItem:sender withUniversityInfo:self.universityID];
    }

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


@end
