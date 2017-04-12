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
        self.layer.borderColor   =  XCOLOR(228, 229, 234).CGColor;
        self.layer.borderWidth   = 1;
        
        
        LogoView *logo =[[LogoView alloc] init];
        self.logo = logo;
        [self  addSubview:logo];
        
        self.nameLab = [self labelWithtextColor:XCOLOR_TITLE  fontSize:XFONT_SIZE(18) numberofLine:NO];
        
        CGFloat  official_Font_Size = XFONT_SIZE(14);
        self.official_nameLab = [self labelWithtextColor:XCOLOR_SUBTITLE fontSize:official_Font_Size numberofLine:YES];
      
        self.address_detailBtn = [self buttonlWithtextColor:XCOLOR_SUBTITLE fontSize:official_Font_Size];
        [self.address_detailBtn setImage:[UIImage imageNamed:@"Uni_anthor"] forState:UIControlStateNormal];
        
         self.websiteBtn = [self buttonlWithtextColor:XCOLOR_SUBTITLE fontSize:official_Font_Size];
        [self.websiteBtn setImage:[UIImage imageNamed:@"Uni_web"] forState:UIControlStateNormal];
         self.websiteBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        
         self.dataView =[[UIView alloc] init];
        [self addSubview:self.dataView];
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = XCOLOR_line;
        [self addSubview:self.line];
        
        self.introductionLab = [self labelWithtextColor:XCOLOR_DESC fontSize:XFONT_SIZE(14)  numberofLine:YES];
        
        UIView *gradientBgView = [[UIView alloc] init];
        [self addSubview:gradientBgView];
        self.gradientBgView = gradientBgView;
        
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        UIColor *colorOne = [UIColor colorWithWhite:1 alpha:0];
        UIColor *colorTwo = [UIColor colorWithWhite:1 alpha:1];
        gradient.colors           = [NSArray arrayWithObjects:
                                     (id)colorOne.CGColor,
                                     (id)colorTwo.CGColor,
                                     nil];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(0, 0.3);
        [self.gradientBgView.layer insertSublayer:gradient atIndex:0];
        self.gradient = gradient;
        
        
        self.moreBtn = [self buttonlWithtextColor:XCOLOR_RED fontSize:16];
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
    self.logo.frame = itemFrame.logo_Frame;
    
    
    self.nameLab.text = item.name;
    self.nameLab.frame = itemFrame.name_Frame;
    
    
    self.official_nameLab.text = item.official_name;
    self.official_nameLab.frame = itemFrame.official_nameFrame;
    
    
    NSRange wRange = [item.website rangeOfString:@"www"];
    NSString *webStr = [item.website substringWithRange:NSMakeRange(wRange.location, item.website.length - wRange.location)];
    [self.websiteBtn setTitle: webStr  forState:UIControlStateNormal];
    self.websiteBtn.frame = itemFrame.website_Frame;
    

    [self.address_detailBtn setTitle:[NSString stringWithFormat:@"%@",item.address_long] forState:UIControlStateNormal];
    CGFloat addressWidth = [self.address_detailBtn.currentTitle KD_sizeWithAttributeFont:self.address_detailBtn.titleLabel.font].width;
    if (addressWidth > (itemFrame.address_detailFrame.size.width - 30)) {
        
        [self.address_detailBtn setTitle:itemFrame.item.address_short forState:UIControlStateNormal];
    }
    self.address_detailBtn.frame = itemFrame.address_detailFrame;
    

    
    self.dataView.frame = itemFrame.dataView_Frame;
    self.line.frame =  itemFrame.lineFrame;
    
    self.introductionLab.text = item.introduction;
    self.introductionLab.frame = itemFrame.introduction_Frame;
    
    self.moreBtn.frame = itemFrame.more_Frame;
    
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
        
        NSString *chengji =[NSString stringWithFormat:@"%@",TF];
        
        NSString *TYtitle = @"托福+(本科:硕士)";
        if (regular_degree_YS && master_degree_YS){
        
                TYtitle = @"雅思+(本科:硕士)";
                chengji = YS;
        }
        
        UniversityDetailItem *ys_item  = [UniversityDetailItem ItemInitWithImage:@"Uni_tuofu"  title:TYtitle count:chengji];
        [self.dataView addSubview:ys_item];
        
        CGFloat school_fee_floor = [item.school_fee_floor floatValue];
        CGFloat school_fee_limit = [item.school_fee_limit floatValue];
        NSString *fee =[NSString stringWithFormat:@"%.2lf - %.2lf",school_fee_floor,school_fee_limit];
        NSString *fee_title = @"学费+(万英镑/学年)";
        
        if ([itemFrame.item.country containsString:@"澳"] ) {
            fee_title = @"学费+(万澳元/学年)";
        }else if([itemFrame.item.country containsString:@"美"]){
            fee_title = @"学费+(万美元/学年)";
        }
        
        UniversityDetailItem *fee_item  = [UniversityDetailItem ItemInitWithImage:@"Uni_Fee"  title:fee_title count:fee];
        [self.dataView addSubview:fee_item];
        
        
        CGFloat employment_rate = [item.employment_rate floatValue];
        NSString *employment =[NSString stringWithFormat:@"%.1f%%",employment_rate*100];
         UniversityDetailItem *emp_item  = [UniversityDetailItem ItemInitWithImage:@"Uni_foregin"  title:@"就业率" count:employment];
        [self.dataView addSubview:emp_item];
        
        
        CGFloat foreign_student_rate = [item.foreign_student_rate floatValue];
        NSString *foreign_student =[NSString stringWithFormat:@"%.f%% : %.f%%",(1-foreign_student_rate)*100,foreign_student_rate*100];
        UniversityDetailItem *foreign_item  = [UniversityDetailItem ItemInitWithImage:@"Uni_rate"  title:@"本地:国际" count:foreign_student];
        [self.dataView addSubview:foreign_item];
        
        
        CGFloat itemW = itemFrame.dataView_Frame.size.width * 0.25;
        CGFloat itemH = itemFrame.dataView_Frame.size.height;
        CGFloat itemY = 0;
        CGFloat itemX = 0;
        for (NSInteger index = 0; index < self.dataView.subviews.count; index ++) {
            
            UniversityDetailItem *itemView = (UniversityDetailItem *)self.dataView.subviews[index];
            
            itemX = itemW  * index;
            
            itemView.frame = CGRectMake(itemX, itemY, itemW, itemH);
        }
 
        
    }
    
    
    
}

-(void)onMoreClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (self.actionBlock)  self.actionBlock(sender);
 
}



 






@end
