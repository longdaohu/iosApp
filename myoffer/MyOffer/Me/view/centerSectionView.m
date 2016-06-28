//
//  centerSectionView.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/24.
//  Copyright © 2015年 UVIC. All rights reserved.
//


#import "centerSectionView.h"
#include "CenterSectionItem.h"
@interface centerSectionView()
@property(nonatomic,strong)NSArray *lines;
@property(nonatomic,strong)UIView *topLine;
 @end

@implementation centerSectionView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =XCOLOR_WHITE;
        
        CenterSectionItem *pipei  =[CenterSectionItem viewWithIcon:@"center_pipei" title:@"智能匹配" subtitle:@"0 所"];
        pipei.tag = 1;
        pipei.actionBlack = ^(UIButton *sender){
            
            if (self.sectionBlock) {
        
                self.sectionBlock(sender);
            }
        };
        
        CenterSectionItem *favor  =[CenterSectionItem viewWithIcon:@"center_Favorite" title:@"收藏院校" subtitle:@"0 所"];
        favor.tag = 2;
        favor.actionBlack = ^(UIButton *sender){
         
            if (self.sectionBlock) {
                
                self.sectionBlock(sender);
            }
        };
        CenterSectionItem *service  =[CenterSectionItem viewWithIcon:@"center_service" title:@"增值服务" subtitle:@"基本免费包"];
        service.tag = 3;
        service.actionBlack = ^(UIButton *sender){
            
            if (self.sectionBlock) {
                
                self.sectionBlock(sender);
            }
        };
        
        [self addSubview:pipei];
        [self addSubview:favor];
        [self addSubview:service];
        self.items = @[pipei,favor,service];
        
        UIView *lineOne =[[UIView alloc] init];
        UIView *lineTwo =[[UIView alloc] init];
        UIView *lineTop =[[UIView alloc] init];
        self.lines = @[lineOne,lineTwo,lineTop];
        for (UIView *line in self.lines) {
            [self addSubview:line];
            line.backgroundColor = XCOLOR_LIGHTGRAY;
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    

    CGFloat itemY = 0;
    CGFloat itemW = XScreenWidth / 3;
    CGFloat itemH = self.bounds.size.height;
    
    for (NSInteger index = 0; index < self.items.count; index++) {
        
        CGFloat itemX = index * itemW;

        CenterSectionItem *itemView = self.items[index];
        
        itemView.frame = CGRectMake( itemX, itemY, itemW, itemH);
        
    }
    
    
    
    CGFloat lineW = 0.5;
    CGFloat lineH = self.bounds.size.height * 0.5;
    CGFloat lineY = lineH * 0.5;
    
    for (NSInteger index = 0; index < self.lines.count - 1; index ++) {
        
        CGFloat lineX = itemW * (index + 1);

        UIView *line = self.lines[index];
        
        line.frame = CGRectMake(lineX, lineY,  lineW, lineH);
        
    }
    
    UIView *top =self.lines[2];
    top.frame = CGRectMake(0, 0, XScreenWidth, lineW);
    

}

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//        self.ButtonBackgroundView = [[UIView alloc] init];
//        self.ButtonBackgroundView.backgroundColor  = [UIColor whiteColor];
//        [self addSubview:self.ButtonBackgroundView];
//        
//        self.CenterLine =[[UIView alloc] init];
//        self.CenterLine.backgroundColor = BACKGROUDCOLOR;
//        [self.ButtonBackgroundView addSubview:self.CenterLine];
//        
//        self.LeftBtn = [self addButtonWithImage:@"center_pipei" andButtonTag:10];
//        [self.ButtonBackgroundView addSubview:self.LeftBtn];
//        
//        self.RightBtn = [self addButtonWithImage:@"center_Favor" andButtonTag:11];
//        [self.ButtonBackgroundView addSubview:self.RightBtn];
//        
//    }
//    return self;
//}
//
//
//
//
////生成Button快捷方式
//-(UIButton *)addButtonWithImage:(NSString *)imageName andButtonTag:(NSInteger)tag;
//{
//    UIButton *sender =[[UIButton alloc] init];
//    sender.titleEdgeInsets = UIEdgeInsetsMake(-8, 15, 0, 0);
//    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [sender.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    sender.tag = tag;
//    sender.titleLabel.numberOfLines = 0;
//    sender.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [sender  addTarget:self action:@selector(centerSectionViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    return sender;
//}
//
-(void)setPipeiCount:(NSInteger)PipeiCount
{
    _PipeiCount = PipeiCount;
    
    CenterSectionItem *pipei  = self.items[0];
    pipei.count =  [NSString stringWithFormat:@"%ld",PipeiCount];
    
}

-(void)setFavoriteCount:(NSInteger)FavoriteCount
{
    _FavoriteCount = FavoriteCount;
    CenterSectionItem *favor  = self.items[1];
    favor.count =  [NSString stringWithFormat:@"%ld ",FavoriteCount];
    
}
//
//-(void)AttributetitleWithCount:(NSString *)countStr andtitle:(NSString *)titleStr andButton:(UIButton *)sender
//{
//    //富文本处理
//    NSRange keyRange = [titleStr rangeOfString:countStr];
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
//    [AttributedStr addAttribute:NSForegroundColorAttributeName  value:[UIColor darkGrayColor]   range:keyRange];
//    [AttributedStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:15.0]   range:keyRange];
//    [AttributedStr addAttribute:NSBaselineOffsetAttributeName   value:@(-8)   range:keyRange];
//    [sender setAttributedTitle:AttributedStr forState:UIControlStateNormal];
//}
//
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGFloat SX = 0;
//    CGFloat SY = 1;
//    CGFloat SW = APPSIZE.width;
//    CGFloat SH = self.frame.size.height - 10;
//    self.ButtonBackgroundView.frame = CGRectMake(SX, SY, SW, SH);
//    
//    self.CenterLine.frame = CGRectMake(SW*0.5 - 0.5, 10 , 1, SH - 20 );
//    
//    self.LeftBtn.frame = CGRectMake(0, 0, SW*0.5 - 0.5 , SH);
//    
//    self.RightBtn.frame = CGRectMake(SW*0.5+ 0.5  , 0, SW*0.5 , SH);
//    
//}
//
//- (void)centerSectionViewButtonPressed:(UIButton *)sender {
//    
//    if (self.sectionBlock) {
//        
//        self.sectionBlock(sender);
//    }
//}


@end
