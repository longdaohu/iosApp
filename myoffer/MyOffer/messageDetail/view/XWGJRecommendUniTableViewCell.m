//
//  RecommendUniTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJRecommendUniTableViewCell.h"
#import "UILabel+ResizeHelper.h"
#import "UniversityObj.h"
@interface XWGJRecommendUniTableViewCell()
@property(nonatomic,strong)LogoView *LogoMView;    //LOGO图片
@property(nonatomic,strong)UILabel *titleLabel;    //学校名称
@property(nonatomic,strong)UILabel *subTitleLabel; //主要显示英文学校名称
@property(nonatomic,strong)UILabel *LocalLabel;    //地理位置
@property(nonatomic,strong)UIImageView *Anchor;    //地理图标
@property(nonatomic,strong)UILabel *rankLabel;     //排名
@property(nonatomic,strong)UIView *starBackground;  //用于显示 星号图标
@property(nonatomic,strong)UIImageView *RecommendMV;
@property(nonatomic,strong)UIButton *AddBtn;
@property(nonatomic,assign)BOOL isStart;

@end
@implementation XWGJRecommendUniTableViewCell

+(instancetype)CreateCellWithTableView:(UITableView *)tableView
{
    
    static NSString *Identifier = @"uni";
    
    XWGJRecommendUniTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        
        cell =[[XWGJRecommendUniTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.LogoMView =[[LogoView alloc] init];
        [self.contentView addSubview:self.LogoMView];
        
        self.titleLabel =[[UILabel alloc] init];
        self.titleLabel.font =[UIFont systemFontOfSize:UNIVERISITYTITLEFONT];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.subTitleLabel =[[UILabel alloc] init];
        self.subTitleLabel.numberOfLines = 2;
        self.subTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.subTitleLabel.font =[UIFont systemFontOfSize:UNIVERISITYSUBTITLEFONT];
        [self.contentView addSubview:self.subTitleLabel];
        
        self.Anchor = [[UIImageView alloc] init];
        self.Anchor.image = [UIImage imageNamed:@"anchor"];
        [self.contentView addSubview:self.Anchor];
        
        self.LocalLabel =[[UILabel alloc] init];
        self.LocalLabel.textColor = XCOLOR_DARKGRAY;
        self.LocalLabel.font =[UIFont systemFontOfSize:UNIVERISITYLOCALFONT];
        [self.contentView addSubview:self.LocalLabel];
        
        
        self.rankLabel =[[UILabel alloc] init];
        self.rankLabel.textColor = XCOLOR_DARKGRAY;
        self.rankLabel.font =[UIFont systemFontOfSize:UNIVERISITYRANKFONT];
        [self.contentView addSubview:self.rankLabel];
        
        self.starBackground =[[UIView alloc] init];
        [self.contentView addSubview:self.starBackground];
        
        for (NSInteger i = 0; i< 5; i++) {
            UIImageView *mv =[[UIImageView alloc] init];
            mv.contentMode = UIViewContentModeScaleAspectFit;
            [self.starBackground addSubview:mv];
        }
        

        
        
        
        self.AddBtn =[[UIButton alloc] init];
        self.AddBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.AddBtn.layer.cornerRadius = 4;
        self.AddBtn.layer.masksToBounds = YES;
        self.AddBtn.backgroundColor = XCOLOR_RED;
        [self.AddBtn addTarget:self action:@selector(AddApplication:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.AddBtn];
        
        self.RecommendMV =[[UIImageView alloc] init];
        self.RecommendMV.image = [UIImage imageNamed:@"hot_cn"];
        self.RecommendMV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.RecommendMV];
        
        self.contentView.backgroundColor  = XCOLOR_WHITE;
    }
    
    return self;
}

-(void)AddApplication:(UIButton *)sender
{
    if (self.ActionBlock) {
        
        self.ActionBlock(sender);
        
    }
}


-(void)setUni:(UniversityObj *)uni
{
    _uni =  uni;
    
    
    [self.LogoMView.logoImageView KD_setImageWithURL:uni.logoName];
    
    self.titleLabel.text =  uni.titleName;//UniversityInfo[@"name"];
    
    self.subTitleLabel.text = uni.subTitleName;//UniversityInfo[@"official_name"];
    
    self.LocalLabel.text = [NSString stringWithFormat:@"%@ - %@", uni.countryName, uni.cityName];
    
    self.isStart = [uni.countryName  isEqualToString:GDLocalizedString(@"CategoryVC-AU")]?YES:NO;
    
    self.starBackground.hidden = !self.isStart;
    
    if (self.isStart) {
        
        self.rankLabel.text = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
        
        //用于防止数据异常太大出现冲突情况
        NSInteger StarCount =  [uni.RANKTIName intValue] > 5 ? 5 : [uni.RANKTIName intValue];
        
        for (NSInteger i =0; i< StarCount ; i++) {
            
            UIImageView *mv = (UIImageView *)self.starBackground.subviews[i];
            
            mv.image = [UIImage imageNamed:@"star"];
        }
        
        for (NSInteger i = StarCount ; i<self.starBackground.subviews.count; i++) {
            
            UIImageView *mv = (UIImageView *)self.starBackground.subviews[i];
            
            mv.image = nil;
        }
        
    }else{
        
        
        NSString   *rankStr01 = [uni.RANKTIName intValue] == 99999 ? GDLocalizedString(@"SearchResult_noRank"):uni.RANKTIName;
        
        self.rankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"SearchRank_Country"),rankStr01];
        
    }
    
    
    NSString *addName = uni.in_cart ? @"已添加" :@"加入申请" ;
    
    [self.AddBtn setTitle:addName forState:UIControlStateNormal];
    
    self.AddBtn.enabled = !uni.in_cart;
    
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat RCx = APPSIZE.width - (50 + 5 * FONT_SCALE);
    CGFloat RCy = 0;
    CGFloat RCw = (50 + 5 * FONT_SCALE);
    CGFloat RCh = RCw;
    self.RecommendMV.frame = CGRectMake(RCx,RCy, RCw ,RCh);
    
    
    CGFloat Logox = ITEM_MARGIN;
    CGFloat Logoy = ITEM_MARGIN;
    CGFloat Logow = 100 - 2 * ITEM_MARGIN;
    CGFloat Logoh = Logow;
    self.LogoMView.frame = CGRectMake(Logox, Logoy, Logow, Logoh);
    
    CGFloat Tx = CGRectGetMaxX(self.LogoMView.frame) + 10;
    CGFloat Ty = Logoy;
    CGFloat Tw = APPSIZE.width - Tx;
    CGFloat Tww = APPSIZE.width - Tx -60;
    CGFloat Th = UNIVERSITY_TITLEHIGH;
    self.titleLabel.frame = CGRectMake(Tx, Ty, Tww, Th);
    
    CGFloat subx = Tx;
    CGFloat suby = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat subw = Tw;
    CGFloat subh = UNIVERSITY_SUBTITLEHIGH;
    if (self.subTitleLabel.text) {
     
          subh = [self getContentBoundWithTitle:self.subTitleLabel.text andFontSize:UNIVERISITYSUBTITLEFONT andMaxWidth:subw].height;
        
     }
    self.subTitleLabel.frame = CGRectMake(subx, suby, subw, subh);
    
    
    if (self.rankLabel.text) {
        
        CGFloat Rankx = subx;
        CGFloat Rankw = subw;
        CGSize  rankSize = [self.rankLabel.text KD_sizeWithAttributeFont: FontWithSize(UNIVERISITYRANKFONT)];
        CGFloat Rankh = rankSize.height;
        CGFloat Ranky = CGRectGetMaxY(self.LogoMView.frame) - Rankh + 3;
        
  
        if (!self.isStart) {
            
            self.rankLabel.frame = CGRectMake(Rankx, Ranky, Rankw, Rankh);
            
        }else{
            
            NSString *rank  = [NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
            
            CGSize rankSize = [rank KD_sizeWithAttributeFont:FontWithSize(UNIVERISITYRANKFONT)];
            
            self.rankLabel.frame = CGRectMake(Rankx, Ranky, rankSize.width, Rankh);
            
            self.starBackground.frame = CGRectMake(CGRectGetMaxX(self.rankLabel.frame), Ranky,100,20);
            
            for (NSInteger i =0; i < self.starBackground.subviews.count; i++) {
                
                UIImageView *imageV = (UIImageView *)self.starBackground.subviews[i];
                
                imageV.frame = CGRectMake(20*i, 3, 15, 15);
            }
        }
        
    }
    
    
    
    CGFloat Anchorx = Tx;
    CGFloat Anchorw = UNIVERSITY_LOCALHIGH;
    CGFloat Anchorh = UNIVERSITY_LOCALHIGH;
    CGFloat Anchory = CGRectGetMinY(self.rankLabel.frame) - UNIVERSITY_LOCALHIGH - 2;
    self.Anchor.frame = CGRectMake(Anchorx, Anchory, Anchorw, Anchorh);
    
    CGFloat LOx = CGRectGetMaxX(self.Anchor.frame) + 5;
    CGFloat LOy = Anchory +2;
    CGFloat LOw = Tw;
    CGFloat LOh = UNIVERSITY_LOCALHIGH;
    self.LocalLabel.frame = CGRectMake(LOx,LOy,LOw, LOh);
    
    
    CGFloat addx = XScreenWidth - (65 + KDUtilSize(0) * 6);
    CGFloat addw = 60;
    CGFloat addh = 25;
    CGFloat addy =  0.55 * (100 -addh);

    self.AddBtn.frame = CGRectMake(addx,addy,addw, addh);
    

}

-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}


@end
