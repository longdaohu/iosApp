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
     
        UIFont *titleFont = XFONT(XFONT_SIZE(16));
        
        //1 、 查看所有专业
        UIButton *subjectBtn = [[UIButton alloc] init];
        subjectBtn.layer.borderWidth = 1;
        subjectBtn.layer.borderColor = XCOLOR_RED.CGColor;
        [subjectBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
        [self addButton:subjectBtn title:@"查看所有专业" titleFont:titleFont tag:10];
        self.subjectBtn = subjectBtn;

        //2 、 测试我的入学率
        UIButton *rateBtn = [[UIButton alloc] init];
        rateBtn.tag = 11;
        [self addButton:rateBtn title:@"测试我的入学率" titleFont:titleFont tag:11];
        rateBtn.backgroundColor = XCOLOR_RED;
        [rateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rateBtn = rateBtn;
        
        //3 、获得offer的概率
        UILabel *showLab = [UILabel labelWithFontsize:XFONT_SIZE(14) TextColor:XCOLOR_TITLE TextAlignment:NSTextAlignmentCenter];
        showLab.hidden = YES;
        showLab.numberOfLines = 0;
        self.showLab = showLab;
        [self  addSubview:showLab];

        //4 、免费申请
        UIButton *ApplyBtn = [[UIButton alloc] init];
        ApplyBtn.backgroundColor = XCOLOR_RED;
        [self addButton:ApplyBtn title:@"免费申请" titleFont:titleFont tag:12];
        [ApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.ApplyBtn = ApplyBtn;
        ApplyBtn.hidden = YES;
        
    }
    return self;
}

- (void)addButton:(UIButton *)sender title:(NSString *)title titleFont:(UIFont *)font tag:(NSInteger)tag{

    sender.layer.cornerRadius = CORNER_RADIUS;
    [sender setTitle:title forState:UIControlStateNormal];
    [self addSubview:sender];
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    sender.titleLabel.font = font;


    
}

- (void)setUni_country:(NSString *)uni_country{

    _uni_country = uni_country;
    
    if ([uni_country isEqualToString:@"美国"] || [uni_country isEqualToString:@"新西兰"]) {
        
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
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:XPERCENT * 17]  range:showRange];
    self.showLab.attributedText = attr;
    
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize footerSize = self.bounds.size;
    
    self.top_line.frame = CGRectMake(0, 0, footerSize.width, LINE_HEIGHT);
    
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

- (void)footeTouchEnable:(BOOL)enable{

    CGFloat alp = enable ? 1 : 0;
    
    if (!enable) {
        
        self.alpha = alp;
        
        return;
    }
    
    WeakSelf
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        weakSelf.alpha = alp;
    }];
    
    
    
    
}

@end
