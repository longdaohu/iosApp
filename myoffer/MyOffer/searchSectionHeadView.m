//
//  searchSectionHeadView.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "searchSectionHeadView.h"
#import "UILabel+ResizeHelper.h"


@interface searchSectionHeadView()
@property(nonatomic,strong)LogoView *LogoMView;     //LOGO图片
@property(nonatomic,strong)UILabel *TitleLabel;     //学校名称
@property(nonatomic,strong)UILabel *SubTitleLabel;  //主要显示英文学校名称
@property(nonatomic,strong)UILabel *LocalLabel;     //地理位置
@property(nonatomic,strong)UILabel *RankLabel;      //排名
@property(nonatomic,strong)UIView *StarBackground;  //用于显示 星号图标

@end

@implementation searchSectionHeadView


+(instancetype)CreateSectionViewWithTableView:(UITableView *)tableView
{
    static NSString *Identifier =@"identifier";
    searchSectionHeadView *sectionHeader =[tableView dequeueReusableHeaderFooterViewWithIdentifier:Identifier];
    if (!sectionHeader) {
        sectionHeader = [[searchSectionHeadView alloc] initWithReuseIdentifier:Identifier];
    }
    return sectionHeader;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.LogoMView =[[LogoView alloc] init];
        [self addSubview:self.LogoMView];
        
        self.TitleLabel =[[UILabel alloc] init];
        self.TitleLabel.font =[UIFont systemFontOfSize:UNIVERISITYTITLEFONT];
        [self addSubview:self.TitleLabel];
        
        self.SubTitleLabel =[[UILabel alloc] init];
        self.SubTitleLabel.font =[UIFont systemFontOfSize:UNIVERISITYSUBTITLEFONT];
        [self addSubview:self.SubTitleLabel];
        
        self.LocalLabel =[[UILabel alloc] init];
        self.LocalLabel.textColor = [UIColor darkGrayColor];
        self.LocalLabel.font =[UIFont systemFontOfSize:UNIVERISITYLOCALFONT];
        [self addSubview:self.LocalLabel];
        
        
        self.RankLabel =[[UILabel alloc] init];
        self.RankLabel.textColor = [UIColor darkGrayColor];
        self.RankLabel.font =[UIFont systemFontOfSize:UNIVERISITYRANKFONT];
        [self addSubview:self.RankLabel];
        
         self.StarBackground =[[UIView alloc] init];
        [self addSubview:self.StarBackground];
        
        for (NSInteger i = 0; i< 5; i++) {
            UIImageView *mv =[[UIImageView alloc] init];
            mv.contentMode = UIViewContentModeScaleAspectFit;
            [self.StarBackground addSubview:mv];
        }
  
        self.RecommendMV =[[UIImageView alloc] init];
        self.RecommendMV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.RecommendMV];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroudView:)];
        [self addGestureRecognizer:tap];
        
        self.contentView.backgroundColor  = [UIColor whiteColor];

    }
    return self;
}

-(void)setIsStart:(BOOL)isStart
{
    _isStart = isStart;
}

-(void)setUniObj:(UniversityObj *)uniObj
{
    _uniObj = uniObj;
    
    
    [self.LogoMView.logoImageView KD_setImageWithURL:uniObj.logoName];
  
    self.TitleLabel.text = uniObj.titleName;
    
    self.SubTitleLabel.text = uniObj.subTitleName;
 
    self.LocalLabel.text =[NSString stringWithFormat:@"%@：%@ - %@",GDLocalizedString(@"UniversityDetail-005"),uniObj.countryName, uniObj.stateName];
    
    
    BOOL RankTIType = [self.optionOrderBy isEqualToString:RANKTI];
    
      self.StarBackground.hidden = !self.isStart;
    
      if (!self.isStart) {
          
        if (RankTIType) {
            
            NSString   *rankStr01 = uniObj.RANKTIName.intValue == 99999?GDLocalizedString(@"SearchResult_noRank"):uniObj.RANKTIName;
            self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
            
        }else{
               NSString   *rankStr02 = uniObj.rankName.intValue == 99999?GDLocalizedString(@"SearchResult_noRank"):uniObj.rankName;
               self.RankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_World"), rankStr02];
        }
          
    }else{
    
         self.RankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
         for (NSInteger i =0; i<uniObj.RANKTIName.integerValue; i++) {
            UIImageView *mv = (UIImageView *)self.StarBackground.subviews[i];
            mv.image = [UIImage imageNamed:@"star"];
        }
         for (NSInteger i =uniObj.RANKTIName.integerValue; i<self.StarBackground.subviews.count; i++) {
             UIImageView *mv = (UIImageView *)self.StarBackground.subviews[i];
            mv.image = nil;
        }
        
    }
         NSString *lang =[InternationalControl userLanguage];
         NSString *imageName = [lang containsString:@"en"]? @"hot_en":@"hot_cn";
         UIImage *MVimage =[UIImage imageNamed:imageName];
         self.RecommendMV.image = uniObj.isHot ? MVimage:nil;
    
}


-(void)tapBackgroudView:(UITapGestureRecognizer *)tap
{
    if (self.actionBlock) {
        
        self.actionBlock(self.uniObj.universityID);
    }

}



-(void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat RCx = APPSIZE.width - 60;
    CGFloat RCy = 0;
    CGFloat RCw = 60;
    CGFloat RCh = 60;
    self.RecommendMV.frame = CGRectMake(RCx,RCy, RCw ,RCh);
    
    CGFloat Lx = 15;
    CGFloat Ly = 15;
    CGFloat Lw = 70;
    CGFloat Lh = 70;
    self.LogoMView.frame = CGRectMake(Lx, Ly, Lw, Lh);
    
    CGFloat Tx = CGRectGetMaxX(self.LogoMView.frame) + 10;
    CGFloat Ty = 15;
    CGFloat Tw = APPSIZE.width - Tx;
    CGFloat Tww = APPSIZE.width - Tx -60;
    CGFloat Th = UNIVERSITY_TITLEHIGH;
    self.TitleLabel.frame = CGRectMake(Tx, Ty, Tww, Th);
    
    CGFloat Sx = Tx;
    CGFloat Sy = CGRectGetMaxY(self.TitleLabel.frame);
    CGFloat Sw = Tw;
    CGFloat Sh = UNIVERSITY_SUBTITLEHIGH;
    self.SubTitleLabel.frame = CGRectMake(Sx, Sy, Sw, Sh);
    

    CGFloat LOx = Tx;
    CGFloat LOy = CGRectGetMaxY(self.SubTitleLabel.frame) + SUB_LOCAL_MAGIN;
    CGFloat LOw = Tw;
    CGFloat LOh = UNIVERSITY_LOCALHIGH;
    self.LocalLabel.frame = CGRectMake(LOx,LOy,LOw, LOh);
    
    CGFloat Rx = Tx;
    CGFloat Ry = CGRectGetMaxY(self.LocalLabel.frame);
    CGFloat Rh = UNIVERSITY_RANKHIGH;
    if (!self.isStart) {
        CGFloat Rw = Tw;
        self.RankLabel.frame = CGRectMake(Rx,Ry,Rw, Rh);
    }else{
    
        NSString *rank  = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        CGSize rankSize = [rank KD_sizeWithAttributeFont:[UIFont systemFontOfSize:13]];
        
        self.RankLabel.frame = CGRectMake(Rx,Ry,rankSize.width, Rh);

        self.StarBackground.frame = CGRectMake(CGRectGetMaxX(self.RankLabel.frame), Ry,100, Rh);

        for (NSInteger i =0; i < self.StarBackground.subviews.count; i++) {
           
            UIImageView *imageV = (UIImageView *)self.StarBackground.subviews[i];
            
            imageV.frame = CGRectMake(20*i, 3, 15, 15);
         }
    }
}
@end
