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
@property(nonatomic,strong)CALayer *top_line;
@end

@implementation UniversityFooterView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CALayer *top_line_layer = [CALayer layer];
        top_line_layer.backgroundColor = XCOLOR_line.CGColor;
        [self.layer addSublayer:top_line_layer];
        self.top_line = top_line_layer;
        
        self.backgroundColor = XCOLOR_WHITE;
     
        UIButton *subjectBtn = [[UIButton alloc] init];
        subjectBtn.layer.cornerRadius = CORNER_RADIUS;
        subjectBtn.layer.borderWidth = 1;
        subjectBtn.layer.borderColor = XCOLOR_RED.CGColor;
        [subjectBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
//        [subjectBtn setTitleColor:XCOLOR_line forState:UIControlStateHighlighted];
//        [subjectBtn addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
        [subjectBtn setTitle:@"查看所有专业" forState:UIControlStateNormal];
        [subjectBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subjectBtn];
        self.subjectBtn = subjectBtn;
        subjectBtn.titleLabel.font = XFONT(XPERCENT * 14);
        subjectBtn.tag = 10;

        
        UIButton *rateBtn = [[UIButton alloc] init];
        rateBtn.tag = 11;
        rateBtn.layer.cornerRadius = CORNER_RADIUS;
        rateBtn.backgroundColor = XCOLOR_RED;
        [rateBtn setTitle:@"测试我的入学率" forState:UIControlStateNormal];
        [rateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rateBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rateBtn];
        self.rateBtn = rateBtn;
        rateBtn.titleLabel.font = XFONT(XPERCENT * 14);
        
        
        UILabel *showLab = [UILabel labelWithFontsize:13 TextColor:XCOLOR_TITLE TextAlignment:NSTextAlignmentCenter];
        showLab.hidden = YES;
        showLab.numberOfLines = 0;
        self.showLab = showLab;
        [self  addSubview:showLab];
        
        UIButton *ApplyBtn = [[UIButton alloc] init];
        ApplyBtn.tag = 12;
        ApplyBtn.layer.cornerRadius = CORNER_RADIUS;
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
        self.ApplyBtn.hidden = NO;
        
    }
    
}


-(void)setLevel:(NSInteger)level{

    _level = level;
    
    if ([self.uni_country isEqualToString:@"美国"]) {
        
        self.showLab.hidden = YES;
        self.rateBtn.hidden = YES;
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
    NSRange showRange = NSMakeRange(offerStr.length, showStri.length - offerStr.length);
    NSMutableAttributedString *attr =  [[NSMutableAttributedString alloc] initWithString:showStri];
    [attr addAttribute:NSForegroundColorAttributeName value:XCOLOR_LIGHTBLUE  range:showRange];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18]  range:showRange];
    self.showLab.attributedText = attr;
    
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize footerSize = self.bounds.size;
    
    self.top_line.frame = CGRectMake(0, 0, footerSize.width, 1);
    
    CGFloat button_hight = 50;
    CGFloat margin = (footerSize.height - button_hight) * 0.5;

    CGFloat rate_X = margin;
    CGFloat rate_Y = margin;
    CGFloat rate_W = (footerSize.width - rate_X * 3) * 0.5;
    CGFloat rate_H = button_hight;
    self.rateBtn.frame = CGRectMake(rate_X, rate_Y , rate_W, rate_H);
   
    self.ApplyBtn.frame = self.rateBtn.frame;
    
    self.showLab.frame = self.rateBtn.frame;
    
    
    CGFloat sub_X = CGRectGetMaxX(self.rateBtn.frame) + margin;
    CGFloat sub_Y = rate_Y;
    CGFloat sub_W = rate_W;
    CGFloat sub_H = rate_H;
    self.subjectBtn.frame = CGRectMake(sub_X, sub_Y, sub_W, sub_H);
    

}

- (void)onClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    UIButton *button = (UIButton *)object;
    
    if ([keyPath isEqualToString:@"highlighted"]) {
        
        if (button.highlighted) {
            
            button.layer.borderColor = XCOLOR_line.CGColor;
            
            return;
        }
        
        button.layer.borderColor = XCOLOR_RED.CGColor;

    }
 
}

*/

@end
