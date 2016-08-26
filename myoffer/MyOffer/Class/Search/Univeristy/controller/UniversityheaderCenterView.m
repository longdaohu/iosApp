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

@interface UniversityheaderCenterView ()
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
        self.layer.borderColor   = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth   = 1;
        
        
        UIImageView *logo =[[UIImageView alloc] init];
        self.logo = logo;
        [self  addSubview:logo];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        
        self.nameLab = [self labelWithtextColor:[UIColor blackColor] fontSize:XPERCENT * 16 numberofLine:NO];
        self.official_nameLab = [self labelWithtextColor:[UIColor lightGrayColor] fontSize:XPERCENT * 11 numberofLine:YES];
        
        
        self.address_detailBtn = [self buttonlWithtextColor:[UIColor lightGrayColor] fontSize:XPERCENT * 12];
        [self.address_detailBtn setImage:[UIImage imageNamed:@"anchor"] forState:UIControlStateNormal];
        self.address_detailBtn.userInteractionEnabled = NO;
        self.websiteBtn = [self buttonlWithtextColor:[UIColor lightGrayColor] fontSize:XPERCENT * 12];
        [self.websiteBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.websiteBtn setImage:[UIImage imageNamed:@"anchor"] forState:UIControlStateNormal];
        [self.websiteBtn setImage:[UIImage imageNamed:@"anchor"] forState:UIControlStateHighlighted];
        self.websiteBtn.tag = 114;

        
        self.dataView =[[UIView alloc] init];
        [self addSubview:self.dataView];
        
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.line];
        
        self.introductionLab = [self labelWithtextColor:[UIColor lightGrayColor] fontSize:XPERCENT * 12  numberofLine:YES];
        
        
        self.moreBtn = [self buttonlWithtextColor:[UIColor redColor] fontSize:XPERCENT * 15];
        self.moreBtn.tag = 113;
        [self.moreBtn setTitle:@"了解详细介绍" forState:UIControlStateNormal];
        self.moreBtn .contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.moreBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
    [self addSubview:sender];
    [sender setTitleColor:color forState:UIControlStateNormal];
    sender.titleLabel.font =XFONT(size);
    sender.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return sender;
}



-(void)setItemFrame:(UniversityNewFrame *)itemFrame{
    
    _itemFrame = itemFrame;
    
    UniversitydetailNew *item = itemFrame.item;
    
    
    [self.logo sd_setImageWithURL:[NSURL URLWithString:item.logo]];
    self.logo.frame = itemFrame.logoFrame;
    
    self.nameLab.text = item.name;
    self.nameLab.frame = itemFrame.nameFrame;
    
    self.official_nameLab.text = item.official_name;
    self.official_nameLab.frame = itemFrame.official_nameFrame;
    
    
    [self.websiteBtn setTitle:[NSString stringWithFormat:@" %@",item.website] forState:UIControlStateNormal];
    self.websiteBtn.frame = itemFrame.websiteFrame;

    [self.address_detailBtn setTitle:[NSString stringWithFormat:@" %@",item.address_detail] forState:UIControlStateNormal];
    self.address_detailBtn.frame = itemFrame.address_detailFrame;
    
    
    self.dataView.frame = itemFrame.dataViewFrame;
    
    self.line.frame =  itemFrame.lineFrame;
    
    self.introductionLab.text = item.introduction;
    self.introductionLab.frame = itemFrame.introductionFrame;
    
    self.moreBtn.frame = itemFrame.moreFrame;
    
    
    UIView *navView           = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.introductionLab.frame) - 15,XScreenWidth, 30)];
    [self insertSubview:navView belowSubview:self.moreBtn];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame            = navView.bounds;
    
    UIColor *colorOne = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:0.0];
    UIColor *colorTwo = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:1.0];
    
    gradient.colors           = [NSArray arrayWithObjects:
                                 (id)colorOne.CGColor,
                                 (id)colorTwo.CGColor,
                                 nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1.0);
    [navView.layer insertSublayer:gradient atIndex:0];
 
    
//    NSLog(@"学费下限 %@\n学费上线 %@\n雅思要求 %@\n托福要求   %@\n 就业率  %@\n  外国学生比例 %@\n",item.school_fee_floor,item.school_fee_limit,item.IELTSRequirement,item.TOEFLRequirement,item.employment_rate,item.foreign_student_rate);
    
    
    UniversityDetailItem *item1  = [UniversityDetailItem ViewWithImage:@"ICON3" title:@"托福/雅思" subtitle:@"-"];
    [self.dataView addSubview:item1];
    
    
    CGFloat school_fee_floor = [item.school_fee_floor floatValue];
    CGFloat school_fee_limit = [item.school_fee_limit floatValue];
    NSString *fee =[NSString stringWithFormat:@"%.2lf : %.2lf",school_fee_floor,school_fee_limit];
    UniversityDetailItem *item2  = [UniversityDetailItem ViewWithImage:@"ICON3" title:@"学费(万英镑/学年)" subtitle:fee];
    [self.dataView addSubview:item2];
    
    
    CGFloat employment_rate = [item.employment_rate floatValue];
    NSString *employment =[NSString stringWithFormat:@"%.1f%%",employment_rate*100];
    UniversityDetailItem *item3  = [UniversityDetailItem ViewWithImage:@"ICON3" title:@"就业率" subtitle:employment];
    [self.dataView addSubview:item3];
    
    
    CGFloat foreign_student_rate = [item.foreign_student_rate floatValue];
    NSString *foreign_student =[NSString stringWithFormat:@"%.f%% : %.f%%",foreign_student_rate*100,(1-foreign_student_rate)*100];
    UniversityDetailItem *item4  = [UniversityDetailItem ViewWithImage:@"ICON3" title:@"本地 : 国际" subtitle:foreign_student];
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

-(void)onClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }

}



 






@end
