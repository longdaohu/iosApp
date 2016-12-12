//
//  UniversityFooterView.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/31.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityFooterView.h"


@interface UniversityFooterView ()
@property(nonatomic,strong)UIButton *ApplyBtn;
@property(nonatomic,strong)UIButton *subjectBtn;
@property(nonatomic,strong)UIButton *rateBtn;
@property(nonatomic,strong)UILabel *showLab;
@end

@implementation UniversityFooterView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
     
        UIButton *subjectBtn = [[UIButton alloc] init];
        subjectBtn.layer.cornerRadius = 4;
        subjectBtn.layer.borderWidth = 1;
        subjectBtn.layer.borderColor = XCOLOR_WHITE.CGColor;
        [subjectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [subjectBtn setTitle:@"查看所有专业" forState:UIControlStateNormal];
        [subjectBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subjectBtn];
        self.subjectBtn = subjectBtn;
        subjectBtn.titleLabel.font = XFONT(XPERCENT * 14);
        subjectBtn.tag = 10;

        
        UIButton *rateBtn = [[UIButton alloc] init];
        rateBtn.tag = 11;
        rateBtn.layer.cornerRadius = 4;
        rateBtn.backgroundColor = XCOLOR_RED;
        [rateBtn setTitle:@"测试我的入学率" forState:UIControlStateNormal];
        [rateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rateBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rateBtn];
        self.rateBtn = rateBtn;
        rateBtn.titleLabel.font = XFONT(XPERCENT * 14);
        
        
        UILabel *showLab = [UILabel labelWithFontsize:XPERCENT * 14 TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentCenter];
        showLab.hidden = YES;
        showLab.numberOfLines = 0;
        self.showLab = showLab;
        [self  addSubview:showLab];
        
        UIButton *ApplyBtn = [[UIButton alloc] init];
        ApplyBtn.tag = 12;
        ApplyBtn.layer.cornerRadius = 4;
        ApplyBtn.backgroundColor = XCOLOR_RED;
        [ApplyBtn setTitle:@"免费申请" forState:UIControlStateNormal];
        [ApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ApplyBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ApplyBtn];
        self.ApplyBtn = ApplyBtn;
        ApplyBtn.titleLabel.font = XFONT(XPERCENT * 14);
        ApplyBtn.hidden = YES;
        
    }
    return self;
}

- (void)setUni_country:(NSString *)uni_country{

    _uni_country = uni_country;
    
    if ([uni_country isEqualToString:@"美国"]) {
        
        self.showLab.hidden = YES;
        self.rateBtn.hidden = YES;
        self.subjectBtn.hidden = YES;
        self.ApplyBtn.hidden = NO;
        
    }
    
}


-(void)setLevel:(NSInteger)level{

    _level = level;
    
    if ([self.uni_country isEqualToString:@"美国"]) {
        
        self.showLab.hidden = YES;
        self.rateBtn.hidden = YES;
        self.subjectBtn.hidden = YES;
        self.ApplyBtn.hidden = NO;
        
        return;
        
    }

    
    if (!self.showLab.hidden) return;
    
    //	'universityId': 'level' // 0:不推荐|1:冲刺|2:核心|3:保底     你获得offer的难易度  蓝字
    
    NSString *levelStr;
    
    switch (level) {
        case 0:
            levelStr = @"极难：不建议申请";
            break;
        case 1:
            levelStr = @"难：不妨一试";
            break;
        case 2:
            levelStr = @"中：重点考虑";
            break;
        case 3:
            levelStr = @"易：成功率较高";
            break;
        default:
            break;
    }
    
    self.showLab.hidden = NO;
    self.rateBtn.hidden = YES;
    
    NSString *offerStr = @"你获得offer的难易度";
    NSString *showStri =  [NSString stringWithFormat:@"%@\n%@",offerStr,levelStr];
    NSRange showRange = NSMakeRange(0, offerStr.length);
    NSMutableAttributedString *attr =  [[NSMutableAttributedString alloc] initWithString:showStri];
    [attr addAttribute:NSForegroundColorAttributeName value:XCOLOR_LIGHTBLUE  range:showRange];
    self.showLab.attributedText = attr;
    
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize footerSize = self.bounds.size;
    
    CGFloat margin = 10;
    
    CGFloat subX = margin;
    CGFloat subY = margin;
    CGFloat subW = (footerSize.width - subX * 3) * 0.5;
    CGFloat subH = footerSize.height - 2 * subY;
    self.subjectBtn.frame = CGRectMake(subX, subY, subW, subH);
    
    CGFloat rateX = CGRectGetMaxX(self.subjectBtn.frame) + margin;
    CGFloat rateY = subY;
    CGFloat rateW = subW;
    CGFloat rateH = subH;
    self.rateBtn.frame = CGRectMake(rateX, rateY , rateW, rateH);
    
    
    CGFloat ApplyY = subY;
    CGFloat ApplyW = subW;
    CGFloat ApplyH = subH;
    CGFloat ApplyX = (footerSize.width - ApplyW) * 0.5;
    self.ApplyBtn.frame = CGRectMake(ApplyX, ApplyY , ApplyW, ApplyH);
    
    self.showLab.frame = self.rateBtn.frame;

}

- (void)onClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
}


@end
