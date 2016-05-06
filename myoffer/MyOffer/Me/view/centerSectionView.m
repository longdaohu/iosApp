//
//  centerSectionView.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/24.
//  Copyright © 2015年 UVIC. All rights reserved.
//


#import "centerSectionView.h"
@interface centerSectionView()
@property(nonatomic,strong)UIView *ButtonBackgroundView;  //按钮背景
@property(nonatomic,strong)UIButton *LeftBtn;  //左边按钮
@property(nonatomic,strong)UIButton *RightBtn; //右边按钮
@property(nonatomic,strong)UIView *CenterLine; //间隔线
@end
@implementation centerSectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.ButtonBackgroundView = [[UIView alloc] init];
        self.ButtonBackgroundView.backgroundColor  = [UIColor whiteColor];
        [self addSubview:self.ButtonBackgroundView];
        
        self.CenterLine =[[UIView alloc] init];
        self.CenterLine.backgroundColor = BACKGROUDCOLOR;
        [self.ButtonBackgroundView addSubview:self.CenterLine];
        
        self.LeftBtn = [self addButtonWithImage:@"center_pipei" andButtonTag:10];
        [self.ButtonBackgroundView addSubview:self.LeftBtn];
        
        self.RightBtn = [self addButtonWithImage:@"center_Favor" andButtonTag:11];
        [self.ButtonBackgroundView addSubview:self.RightBtn];
        
    }
    return self;
}




//生成Button快捷方式
-(UIButton *)addButtonWithImage:(NSString *)imageName andButtonTag:(NSInteger)tag;
{
    UIButton *sender =[[UIButton alloc] init];
    sender.titleEdgeInsets = UIEdgeInsetsMake(-8, 15, 0, 0);
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender.titleLabel setFont:[UIFont systemFontOfSize:18]];
    sender.tag = tag;
    sender.titleLabel.numberOfLines = 0;
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [sender  addTarget:self action:@selector(centerSectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return sender;
}

-(void)setPipeiCount:(NSInteger)PipeiCount
{
    _PipeiCount = PipeiCount;
    
    NSString *countStr =[NSString stringWithFormat:@"%ld %@",(long)PipeiCount,GDLocalizedString(@"Evaluate-dangwei")];

    NSString *leftTitle = [NSString stringWithFormat:@"%@\n%ld %@",GDLocalizedString(@"center-match"),(long)PipeiCount,GDLocalizedString(@"Evaluate-dangwei")];

    [self AttributetitleWithCount:countStr andtitle:leftTitle andButton:self.LeftBtn];

}

-(void)setFavoriteCount:(NSInteger)FavoriteCount
{
    _FavoriteCount = FavoriteCount;
    NSString *countStr =[NSString stringWithFormat:@"%ld %@",(long)FavoriteCount,GDLocalizedString(@"Evaluate-dangwei")];
    NSString *rightTitle = [NSString stringWithFormat:@"%@\n%@",GDLocalizedString(@"center-Favourite"),countStr];
    [self AttributetitleWithCount:countStr andtitle:rightTitle andButton:self.RightBtn];

}

-(void)AttributetitleWithCount:(NSString *)countStr andtitle:(NSString *)titleStr andButton:(UIButton *)sender
{
    //富文本处理
    NSRange keyRange = [titleStr rangeOfString:countStr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
    [AttributedStr addAttribute:NSForegroundColorAttributeName  value:[UIColor darkGrayColor]   range:keyRange];
    [AttributedStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:15.0]   range:keyRange];
    [AttributedStr addAttribute:NSBaselineOffsetAttributeName   value:@(-8)   range:keyRange];
    [sender setAttributedTitle:AttributedStr forState:UIControlStateNormal];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat SX = 0;
    CGFloat SY = 1;
    CGFloat SW = APPSIZE.width;
    CGFloat SH = self.frame.size.height - 10;
    self.ButtonBackgroundView.frame = CGRectMake(SX, SY, SW, SH);
    
    self.CenterLine.frame = CGRectMake(SW*0.5 - 0.5, 10 , 1, SH - 20 );
    
    self.LeftBtn.frame = CGRectMake(0, 0, SW*0.5 - 0.5 , SH);
    
    self.RightBtn.frame = CGRectMake(SW*0.5+ 0.5  , 0, SW*0.5 , SH);
    
}

- (void)centerSectionViewButtonPressed:(UIButton *)sender {
    
    if (self.sectionBlock) {
        
        self.sectionBlock(sender);
    }
}


@end
