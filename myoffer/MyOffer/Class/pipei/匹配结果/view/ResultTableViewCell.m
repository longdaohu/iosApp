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
@property (strong, nonatomic)  UILabel *nameLab;//中文名
@property (strong, nonatomic)  UILabel *official_nameLab;//英文名
@property(nonatomic,strong)UIButton *rankBtn;//排名
@property (strong, nonatomic)  LogoView *iconView;//logo图标
@property(nonatomic,strong)UIButton *address_Btn;//地理位置
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong)UniversityFrame *uniFrame;

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
     rankBtn.userInteractionEnabled = NO;
    
    //地理位置
    UIButton *address_Btn = [[UIButton alloc] init];
    [address_Btn setTitleColor: XCOLOR_SUBTITLE forState:UIControlStateNormal];
    address_Btn.titleLabel.font = XFONT(XFONT_SIZE(13));
    [address_Btn setImage:[UIImage imageNamed:@"Uni_anthor"]  forState:UIControlStateNormal];
    [self.contentView addSubview:address_Btn];
    self.address_Btn = address_Btn;
    address_Btn.userInteractionEnabled = NO;
    [address_Btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    //**号背景
    self.starBgView =[[UIView alloc] init];
    self.starBgView.backgroundColor = XCOLOR_WHITE;
    [self.contentView addSubview:self.starBgView];
    
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *mv =[[UIImageView alloc] init];
        mv.image = [UIImage imageNamed:@"star"];
        mv.contentMode = UIViewContentModeScaleAspectFit;
        [self.starBgView addSubview:mv];
    }
    
    
    [self.selectButton addTarget:self action:@selector(selectCellID:) forControlEvents:UIControlEventTouchUpInside];
    
    //底部分隔线
    UIView *line = [UIView new];
    line.backgroundColor = XCOLOR_line;
    [self.contentView addSubview:line];
    self.line = line;
    
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
    
    self.uniFrame = uniFrame;
    
    [self configureWithUniversityFrame:uniFrame ranking:RANK_TI];
}

- (void)configureWithUniversityFrame:(UniversityFrame *)uniFrame ranking:(NSString *)ranking {
   
    MyOfferUniversityModel *university =  uniFrame.university;
 
    self.nameLab.frame = uniFrame.name_Frame;
    self.rankBtn.frame =uniFrame.rank_Frame;
    self.starBgView.frame = uniFrame.starBgFrame;
    self.official_nameLab.frame = uniFrame.official_Frame;
    self.iconView.frame = uniFrame.icon_Frame;
    self.address_Btn.frame = uniFrame.address_Frame;
    self.line.frame = uniFrame.lineFrame;

    self.optionOrderBy =  @"ranking_ti";
    [self.address_Btn setTitle:university.address_short  forState:UIControlStateNormal];
    self.universityID = university.NO_id;
    self.nameLab.text = university.name;
    self.official_nameLab.text = university.official_name;
    [self.iconView.logoImageView KD_setImageWithURL:university.logo];
    
    self.isStar = [university.country isEqualToString:GDLocalizedString(@"CategoryVC-AU")]?YES:NO;
    self.starBgView.hidden = !self.isStar;
 
    if (!self.isStar) {
        
         BOOL is_rank_ti = [self.optionOrderBy isEqualToString:RANK_TI];
         NSString *title = is_rank_ti ? university.ranking_ti_str :  university.ranking_qs_str;
         [self.rankBtn setTitle:title  forState:UIControlStateNormal];
 
    }else{
        
        [self.rankBtn setTitle:uniFrame.university.ranking_ti_str forState:UIControlStateNormal];
        for (NSInteger i =0; i < self.starBgView.subviews.count; i++) {
            UIView *starView = self.starBgView.subviews[i];
            NSString *star_frame_str  = uniFrame.star_frames[i];
            starView.frame = CGRectFromString(star_frame_str);
        }
        
    }
    
}


- (void)configrationCellLefButtonWithTitle:(NSString  *)title imageName:(NSString *)imageName{

    [self.selectButton setTitle:title  forState:UIControlStateNormal];
    [self.selectButton setImage:XImage(imageName) forState:UIControlStateNormal];
}



- (void)selectCellID:(UIButton *)sender{

    if (self.uniFrame.university.in_cart) return;
    
    if ([self.delegate respondsToSelector:@selector(selectResultTableViewCellItem:withUniversityInfo:)]) {
        
        [self.delegate selectResultTableViewCellItem:sender withUniversityInfo:self.universityID];
    }

}


- (void)separatorLineShow:(BOOL)show{
    
    self.line.hidden = !show;
}




@end
