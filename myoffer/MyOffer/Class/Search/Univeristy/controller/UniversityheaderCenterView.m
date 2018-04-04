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
//详情
@property(nonatomic,strong)UILabel      *introductionLab;
//更多按钮
@property(nonatomic,strong)UIButton     *moreBtn;
//渐变色
@property(nonatomic,strong)UIView       *gradientBgView;
@end

@implementation UniversityheaderCenterView

+(instancetype)headerCenterViewWithBlock:(UniversityCenterViewBlock)actionBlock
{
    UniversityheaderCenterView *headerCenter = [[UniversityheaderCenterView alloc] init];
    headerCenter.actionBlock = actionBlock;
    return headerCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
        
        //logo 学校
        LogoView *logo =[[LogoView alloc] init];
        self.logo = logo;
        [self  addSubview:logo];
        
        //1、大学名称
        self.nameLab = [self labelWithtextColor:XCOLOR_TITLE  fontSize:XFONT_SIZE(18) numberofLine:NO];
        
        //2、大学英文名称
        CGFloat  official_Font_Size = XFONT_SIZE(14);
        self.official_nameLab = [self labelWithtextColor:XCOLOR_SUBTITLE fontSize:official_Font_Size numberofLine:YES];
      
        //3、地址
        self.address_detailBtn = [self buttonlWithtextColor:XCOLOR_SUBTITLE fontSize:official_Font_Size];
        [self.address_detailBtn setImage:[UIImage imageNamed:@"Uni_anthor"] forState:UIControlStateNormal];
        
        //4、网络地址
         self.websiteBtn = [self buttonlWithtextColor:XCOLOR_SUBTITLE fontSize:official_Font_Size];
        [self.websiteBtn setImage:[UIImage imageNamed:@"Uni_web"] forState:UIControlStateNormal];
         self.websiteBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        
        //5、子项容器
         self.dataView =[[UIView alloc] init];
        [self addSubview:self.dataView];
 
        //6、学校简介
        self.introductionLab = [self labelWithtextColor:XCOLOR_DESC fontSize:XFONT_SIZE(14)  numberofLine:YES];
        
        //7、颜色映射
        UIView *gradientBgView = [[UIView alloc] init];
        gradientBgView.backgroundColor = XCOLOR_WHITE;
        [self addSubview:gradientBgView];
        self.gradientBgView = gradientBgView;
        gradientBgView.backgroundColor = XCOLOR_WHITE;
        gradientBgView.layer.shadowColor = XCOLOR_WHITE.CGColor;//shadowColor阴影颜色
        gradientBgView.layer.shadowOffset = CGSizeMake(0,-20);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        gradientBgView.layer.shadowRadius = 10;
        gradientBgView.layer.shadowOpacity = 0.9;//阴影透明度，默认0

        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        UIColor *colorOne = [UIColor colorWithWhite:1 alpha:0];
//        UIColor *colorTwo = [UIColor colorWithWhite:1 alpha:1];
//        gradient.colors           = [NSArray arrayWithObjects:
//                                     (id)colorOne.CGColor,
//                                     (id)colorTwo.CGColor,
//                                     nil];
//        gradient.startPoint = CGPointMake(0, 0);
//        gradient.endPoint = CGPointMake(0, 0.3);
//        [self.gradientBgView.layer insertSublayer:gradient atIndex:0];
//        self.gradient = gradient;
        
        //8、更多
        self.moreBtn = [self buttonlWithtextColor:XCOLOR_LIGHTBLUE fontSize:16];
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
    sender.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    
    return sender;
}


- (void)setUniversityFrame:(UniversityNewFrame *)UniversityFrame{

    
    _UniversityFrame = UniversityFrame;
    
    //8、更多
    self.moreBtn.frame = UniversityFrame.more_Frame;
    //7、颜色映射
    self.gradientBgView.frame = UniversityFrame.gradient_Frame;
    
    //已添加过没必要重复添加
    if (UniversityFrame.uni.has_been_added) return;
    
    self.introductionLab.frame = UniversityFrame.introduction_Frame;
    self.address_detailBtn.frame = UniversityFrame.address_detailFrame;
    self.websiteBtn.frame = UniversityFrame.website_Frame;
    self.official_nameLab.frame = UniversityFrame.official_nameFrame;
    self.nameLab.frame = UniversityFrame.name_Frame;
    self.logo.frame = UniversityFrame.logo_Frame;
    //5、子项容器
    self.dataView.frame = UniversityFrame.dataView_Frame;
    
    
    UniversitydetailNew *item = UniversityFrame.uni;
      //logo 学校
    [self.logo.logoImageView sd_setImageWithURL:[NSURL URLWithString:item.logo]];
    //1、大学名称
    self.nameLab.text = item.name;
    //2、大学英文名称
    self.official_nameLab.text = item.official_name;
    //4、网络地址
    [self.websiteBtn setTitle: item.webpath  forState:UIControlStateNormal];
    //3、地址
    [self.address_detailBtn setTitle:[NSString stringWithFormat:@"%@",item.address_long] forState:UIControlStateNormal];
    
    CGFloat addressWidth = [self.address_detailBtn.currentTitle KD_sizeWithAttributeFont:self.address_detailBtn.titleLabel.font].width;
    if (addressWidth > (UniversityFrame.address_detailFrame.size.width - 30)) {
        [self.address_detailBtn setTitle:UniversityFrame.uni.address_short forState:UIControlStateNormal];
    }
    //6、学校简介
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 6;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:item.introduction];
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraph
                    range:NSMakeRange(0, item.introduction.length)];
    self.introductionLab.attributedText = attrStr;
    
     //更新子项数据
    if (self.dataView.subviews.count == 0)  [self configurationWithUniversity:UniversityFrame];
    
    
}

//更新子项数据
- (void)configurationWithUniversity:(UniversityNewFrame *)UniversityFrame{

    
    UniversitydetailNew *item = UniversityFrame.uni;
    
    //  雅思要求 %@\n托福要求
    NSNumber *regular_degree_TF = item.TOEFLRequirement[@"regular_degree_total"];
    NSNumber *master_degree_TF = item.TOEFLRequirement[@"master_degree_total"];
    NSString *TF  = (regular_degree_TF && master_degree_TF)? [NSString stringWithFormat:@"%@:%@",regular_degree_TF,master_degree_TF]: @"-";
    
    NSNumber *regular_degree_YS = item.IELTSRequirement[@"regular_degree_total"];
    NSNumber *master_degree_YS = item.IELTSRequirement[@"master_degree_total"];
    NSString *YS  = (regular_degree_YS && master_degree_YS)? [NSString stringWithFormat:@"%@:%@",regular_degree_YS,master_degree_YS]: @"-";
    
    NSString *chengji =[NSString stringWithFormat:@"%@",TF];
    
    NSString *TYtitle = @"托福+(本科:硕士)";
    if (regular_degree_YS && master_degree_YS){
        
        TYtitle = @"雅思+(本科:硕士)";
        chengji = YS;
    }
    
    UniversityDetailItem *ys_item  = [UniversityDetailItem ItemInitWithImage:@"Uni_tuofu"  title:TYtitle count:chengji];
    [self.dataView addSubview:ys_item];
    
    //学费
    CGFloat school_fee_floor = [item.school_fee_floor floatValue];
    CGFloat school_fee_limit = [item.school_fee_limit floatValue];
    NSString *fee =[NSString stringWithFormat:@"%.2lf - %.2lf",school_fee_floor,school_fee_limit];
    NSString *fee_title = @"学费+(万英镑/学年)";
    
    if ([item.country containsString:@"澳"] ) {
        fee_title = @"学费+(万澳元/学年)";
    }else if([item.country containsString:@"美"]){
        fee_title = @"学费+(万美元/学年)";
    }
    
    UniversityDetailItem *fee_item  = [UniversityDetailItem ItemInitWithImage:@"Uni_Fee"  title:fee_title count:fee];
    [self.dataView addSubview:fee_item];
    
    
    //就业率
    CGFloat employment_rate = [item.employment_rate floatValue];
    NSString *employment =[NSString stringWithFormat:@"%.1f%%",employment_rate * 100];
    UniversityDetailItem *emp_item  = [UniversityDetailItem ItemInitWithImage:@"Uni_foregin"  title:@"就业率" count:employment];
    [self.dataView addSubview:emp_item];
    
    //本地:国际
    CGFloat foreign_student_rate = [item.foreign_student_rate floatValue];
    NSString *foreign_student =[NSString stringWithFormat:@"%.f%% : %.f%%",(1-foreign_student_rate)*100,foreign_student_rate*100];
    UniversityDetailItem *foreign_item  = [UniversityDetailItem ItemInitWithImage:@"Uni_rate"  title:@"本地:国际" count:foreign_student];
    [self.dataView addSubview:foreign_item];
    
    
    for (NSInteger index = 0; index < UniversityFrame.data_item_Frames.count; index ++) {
        
        UniversityDetailItem *item_View = (UniversityDetailItem *)self.dataView.subviews[index];
        
        item_View.frame = [UniversityFrame.data_item_Frames[index] CGRectValue];
        
        item_View.Uni_Frame = UniversityFrame;
    }

}


-(void)onMoreClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (self.actionBlock)  self.actionBlock(sender);
 
}


- (void)dealloc{
    
    KDClassLog(@" 学校详情  headerCenterView dealloc OK");
    
}






@end
