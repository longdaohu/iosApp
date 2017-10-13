//
//  UniverstityTCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "UniverstityTCell.h"
#import "MyOfferUniversityModel.h"

@interface UniverstityTCell ()
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
//**号背景
@property(nonatomic,strong) UIView *StarsBgView;
//底部分隔线
@property(nonatomic,strong) UIView *bottom_line;
//热门
@property(nonatomic,strong) UIImageView *hot;

@property(nonatomic,strong) UIView *line;


@end

@implementation UniverstityTCell

+ (instancetype)cellViewWithTableView:(UITableView *)tableView{
    
    static NSString *identifier =@"uni_cell";
    
    UniverstityTCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UniverstityTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self makeUI];
    }
    
    return self;
}

- (void)makeUI{

    //LOGO图标
    self.iconView =[[LogoView alloc] init];
    [self.contentView addSubview:self.iconView];
    
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
    self.addressBtn = address_Btn;
    [address_Btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    address_Btn.userInteractionEnabled = NO;
    
    
    
    //底部分隔线
    UIView *line = [UIView new];
    line.backgroundColor = XCOLOR_line;
    [self.contentView addSubview:line];
    self.bottom_line = line;
    
    
    //**号背景
    self.StarsBgView =[[UIView alloc] init];
    [self.contentView addSubview:self.StarsBgView];
    
    for (NSInteger i = 0; i<5; i++) {
        UIImageView *mv =[[UIImageView alloc] init];
        mv.image = [UIImage imageNamed:@"star"];
        mv.contentMode = UIViewContentModeScaleAspectFit;
        [self.StarsBgView addSubview:mv];
    }

    
    UIImageView *hot =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_cn"]];
    hot.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:hot];
    self.hot = hot;
 
    
}

//label创建共有方法
- (UILabel *)getLabelWithFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *Lab =[[UILabel alloc] init];
    Lab.textColor = textColor;
    Lab.font =[UIFont systemFontOfSize:fontSize];
    [self.contentView addSubview:Lab];
    
    return Lab;
}

- (void)separatorLineShow:(BOOL)show{
    
    self.bottom_line.hidden = !show;
}



-(void)setUniFrame:(UniversityFrameNew *)uniFrame
{
    _uniFrame = uniFrame;
    
    MyOfferUniversityModel *university = uniFrame.universtiy;
    
    BOOL isStart = [university.country isEqualToString:GDLocalizedString(@"CategoryVC-AU")] ? YES : NO;
    
    self.StarsBgView.hidden = !isStart;
    
    
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
    
    self.hot.hidden = !uniFrame.universtiy.hot;
    self.hot.frame = uniFrame.hot_Frame;
    
    self.bottom_line.frame =  uniFrame.bottom_line_Frame;
     
    self.StarsBgView.frame = uniFrame.starBgFrame;
    
    //判断是否需要显示*号   澳大利来排名时
    if (isStart) {
        
        [self.rankBtn setTitle:[NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")]  forState:UIControlStateNormal];
        NSInteger  StarCount  = university.ranking_ti.integerValue;
        
        //暂无排名时
        if (StarCount == DEFAULT_NUMBER) {
            
            [self.rankBtn setTitle:@"本国排名：暂无排名"  forState:UIControlStateNormal];
            
            return;
        }
        
        
        for (NSInteger i =0; i < self.StarsBgView.subviews.count; i++) {
            
            UIImageView *imageV = (UIImageView *)self.StarsBgView.subviews[i];
            
            imageV.frame = CGRectMake([uniFrame.starFrames[i] integerValue], 0, 15, 15);
        }
        
        
        for (NSInteger i =0; i < StarCount; i++) {
            
            UIImageView *mv = (UIImageView *)self.StarsBgView.subviews[i];
            
            mv.hidden = NO;
            
        }
        
        for (NSInteger i = StarCount ; i < self.StarsBgView.subviews.count; i++) {
            
            UIImageView *mv = (UIImageView *)self.StarsBgView.subviews[i];
            
            mv.hidden = YES;
        }
        
        
    }else{
        
        //英国排名
        NSString   *rankStr01 = university.ranking_ti.intValue == DEFAULT_NUMBER ? GDLocalizedString(@"SearchResult_noRank"): [NSString stringWithFormat:@"%@",university.ranking_ti];
        [self.rankBtn setTitle:[NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01]   forState:UIControlStateNormal];
    }
    
    
}


- (void)setUniFrameModel:(UniversityFrameModel *)uniFrameModel{
    
    _uniFrameModel = uniFrameModel;
 
    self.hot.hidden = YES;
    
    [self.iconView.logoImageView KD_setImageWithURL:uniFrameModel.universityModel.logo];
    self.iconView.frame = uniFrameModel.icon_Frame;
    
    
    self.nameLab.text = uniFrameModel.universityModel.name;
    self.nameLab.frame = uniFrameModel.name_Frame;
    
    
    self.official_nameLab.text = uniFrameModel.universityModel.official_name;
    self.official_nameLab.frame = uniFrameModel.official_Frame;
    
}


@end


