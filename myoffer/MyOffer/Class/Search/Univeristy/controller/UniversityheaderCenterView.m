//
//  UniversityheaderCenterView.m
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "UniversityheaderCenterView.h"
#import "UniversitydetailNew.h"
#import "UniversityDetailItem.h"
#import "UniversityNewFrame.h"

@interface UniversityheaderCenterView ()
@property(nonatomic,strong)CAGradientLayer *gradient;
//logo 学校
@property(nonatomic,strong)LogoView     *logo;
//学校名称
@property(nonatomic,strong)UILabel      *nameLab;
//英文名称
@property(nonatomic,strong)UILabel      *official_nameLab;
//地址
@property(nonatomic,strong)UIButton     *address_detailBtn;
//web地址
@property(nonatomic,strong)UIButton     *websiteBtn;
//xx数据
@property(nonatomic,strong)UIView       *dataView;
//分隔线
@property(nonatomic,strong)UILabel      *line;
//详情
@property(nonatomic,strong)UILabel      *introductionLab;
//更多按钮
@property(nonatomic,strong)UIButton     *moreBtn;
//渐变色
@property(nonatomic,strong)UIView       *gradientBgView;
@end

@implementation UniversityheaderCenterView

+(instancetype)View
{
    return  [[UniversityheaderCenterView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderColor   = [UIColor colorWithRed:228/255.0 green:229/255.0 blue:234/255.0 alpha:1].CGColor;
        self.layer.borderWidth   = 1;
        
        
        LogoView *logo =[[LogoView alloc] init];
        self.logo = logo;
        [self  addSubview:logo];
        
        self.nameLab = [self labelWithtextColor:[UIColor blackColor] fontSize:XPERCENT * 16 numberofLine:NO];
        self.official_nameLab = [self labelWithtextColor:[UIColor lightGrayColor] fontSize:XPERCENT * 11 numberofLine:YES];
        
        self.address_detailBtn = [self buttonlWithtextColor:[UIColor lightGrayColor] fontSize:XPERCENT * 12];
        [self.address_detailBtn setImage:[UIImage imageNamed:@"Uni_anthor"] forState:UIControlStateNormal];
        
         self.websiteBtn = [self buttonlWithtextColor:[UIColor lightGrayColor] fontSize:XPERCENT * 12];
        [self.websiteBtn setImage:[UIImage imageNamed:@"Uni_web"] forState:UIControlStateNormal];
         self.websiteBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        
         self.dataView =[[UIView alloc] init];
        [self addSubview:self.dataView];
        
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = XCOLOR_BG;
        [self addSubview:self.line];
        
        self.introductionLab = [self labelWithtextColor:[UIColor lightGrayColor] fontSize:XPERCENT * 12  numberofLine:YES];
 
        
        UIView *gradientBgView = [[UIView alloc] init];
        [self addSubview:gradientBgView];
        self.gradientBgView = gradientBgView;
        
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        UIColor *colorOne = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:0.0];
        UIColor *colorTwo = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:1.0];
        gradient.colors           = [NSArray arrayWithObjects:
                                     (id)colorOne.CGColor,
                                     (id)colorTwo.CGColor,
                                     nil];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(0, 0.3);
        [self.gradientBgView.layer insertSublayer:gradient atIndex:0];
        self.gradient = gradient;
        
        
        self.moreBtn = [self buttonlWithtextColor:XCOLOR_RED fontSize:XPERCENT * 15];
        [self.moreBtn setTitle:@"了解详细介绍" forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"点击隐藏" forState:UIControlStateSelected];
        self.moreBtn .contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.moreBtn addTarget:self action:@selector(onMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        self.moreBtn.userInteractionEnabled = YES;
        self.moreBtn.tag = Uni_Header_CenterItemStyleMore;
        self.moreBtn.clipsToBounds = YES;
    }
    return self;
}


-(UILabel *)labelWithtextColor:(UIColor *)color fontSize:(CGFloat)size numberofLine:(BOOL)isTrue
{
    UILabel *Lab = [[UILabel alloc] init];
    [self addSubview:Lab];
    Lab.textColor = color;
    Lab.font =XFONT(size);
    Lab.numberOfLines = isTrue ? 0 : 1;
    
    return Lab;
}


-(UIButton *)buttonlWithtextColor:(UIColor *)color fontSize:(CGFloat)size
{
    UIButton *sender = [[UIButton alloc] init];
    sender.userInteractionEnabled = NO;
    [self addSubview:sender];
    [sender setTitleColor:color forState:UIControlStateNormal];
    sender.titleLabel.font =XFONT(size);
    sender.imageView.contentMode = UIViewContentModeScaleAspectFit;
    sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return sender;
}



-(void)setItemFrame:(UniversityNewFrame *)itemFrame{
    
    _itemFrame = itemFrame;
    
    UniversitydetailNew *item = itemFrame.item;
    
    [self.logo.logoImageView sd_setImageWithURL:[NSURL URLWithString:item.logo]];
    self.logo.frame = itemFrame.logoFrame;
    
    
    self.nameLab.text = item.name;
    self.nameLab.frame = itemFrame.nameFrame;
    
    
    self.official_nameLab.text = item.official_name;
    self.official_nameLab.frame = itemFrame.official_nameFrame;
    

    [self.websiteBtn setTitle:[NSString stringWithFormat:@" %@",item.website] forState:UIControlStateNormal];
    self.websiteBtn.frame = itemFrame.websiteFrame;
    

    [self.address_detailBtn setTitle:[NSString stringWithFormat:@" %@",item.address_detail] forState:UIControlStateNormal];
    CGFloat addressWidth = [self.address_detailBtn.currentTitle KD_sizeWithAttributeFont:XFONT(XPERCENT * 12)].width;
    if (addressWidth > (itemFrame.address_detailFrame.size.width - 30)) {
        NSString *address = [NSString stringWithFormat:@" %@ | %@",itemFrame.item.country,itemFrame.item.city];
        [self.address_detailBtn setTitle:address forState:UIControlStateNormal];
    }
    self.address_detailBtn.frame = itemFrame.address_detailFrame;
    

    
    self.dataView.frame = itemFrame.dataViewFrame;
    self.line.frame =  itemFrame.lineFrame;
    
    self.introductionLab.text = item.introduction;
    self.introductionLab.frame = itemFrame.introductionFrame;
    
    self.moreBtn.frame = itemFrame.moreFrame;
    
    self.gradientBgView.frame = itemFrame.gradientBgViewFrame;
    self.gradient.frame       = self.gradientBgView.bounds;

 
 
    
    if (self.dataView.subviews.count == 0) {
        
        //  雅思要求 %@\n托福要求
        NSNumber *regular_degree_TF = item.TOEFLRequirement[@"regular_degree_total"];
        NSNumber *master_degree_TF = item.TOEFLRequirement[@"master_degree_total"];
        NSString *TF  = (regular_degree_TF && master_degree_TF)? [NSString stringWithFormat:@"%@:%@",regular_degree_TF,master_degree_TF]: @"-";
        
        NSNumber *regular_degree_YS = item.IELTSRequirement[@"regular_degree_total"];
        NSNumber *master_degree_YS = item.IELTSRequirement[@"master_degree_total"];
        
        NSString *YS  = (regular_degree_YS && master_degree_YS)? [NSString stringWithFormat:@"%@:%@",regular_degree_YS,master_degree_YS]: @"-";
        NSString *chengji =[NSString stringWithFormat:@"%@/%@",YS,TF];
        
        NSString *TYtitle = @"学雅思/托福(本科:硕士)";
        if([itemFrame.item.country containsString:@"美"]){
            
             TYtitle = @"托福(本科:硕士)";
             chengji = TF;
        }
        
        UniversityDetailItem *item1  = [UniversityDetailItem ViewWithImage:@"Uni_tuofu" title:TYtitle subtitle:chengji];
        [self.dataView addSubview:item1];
        
        CGFloat school_fee_floor = [item.school_fee_floor floatValue];
        CGFloat school_fee_limit = [item.school_fee_limit floatValue];
        NSString *fee =[NSString stringWithFormat:@"%.2lf - %.2lf",school_fee_floor,school_fee_limit];
        NSString *title = @"学费(万英镑/学年";
        if ([itemFrame.item.country containsString:@"澳"] ) {
            title = @"学费(万澳元/学年)";
        }else if([itemFrame.item.country containsString:@"美"]){
            title = @"学费(万美元/学年)";
        }
        
        UniversityDetailItem *item2  = [UniversityDetailItem ViewWithImage:@"Uni_Fee" title:title subtitle:fee];
        [self.dataView addSubview:item2];
        
        
        CGFloat employment_rate = [item.employment_rate floatValue];
        NSString *employment =[NSString stringWithFormat:@"%.1f%%",employment_rate*100];
        UniversityDetailItem *item3  = [UniversityDetailItem ViewWithImage:@"Uni_foregin" title:@"就业率" subtitle:employment];
        [self.dataView addSubview:item3];
        
        
        CGFloat foreign_student_rate = [item.foreign_student_rate floatValue];
        NSString *foreign_student =[NSString stringWithFormat:@"%.f%% : %.f%%",(1-foreign_student_rate)*100,foreign_student_rate*100];
        UniversityDetailItem *item4  = [UniversityDetailItem ViewWithImage:@"Uni_rate" title:@"本地 : 国际" subtitle:foreign_student];
        [self.dataView addSubview:item4];
        
        
        for (NSInteger index = 0; index < self.dataView.subviews.count; index ++) {
            UniversityDetailItem *itemView = (UniversityDetailItem *)self.dataView.subviews[index];
            CGFloat itemW = itemFrame.dataViewFrame.size.width * 0.5;
            CGFloat itemH = itemFrame.dataViewFrame.size.height * 0.5;
            CGFloat itemY = itemH  * (index / 2);
            CGFloat itemX = itemW  * (index % 2);
            itemView.frame = CGRectMake(itemX, itemY, itemW, itemH);
        }
 
        
    }
    
}

-(void)onMoreClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }

}



 






@end
