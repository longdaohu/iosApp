//
//  HomeHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeHeaderView.h"
#import "HeadItembgView.h"
#import "XUToolbar.h"

@interface HomeHeaderView ()<HeadItembgViewDelegate,UIScrollViewDelegate>
//logo图片
@property(nonatomic,strong)UIImageView *Logo;
//汉堡按钮
@property(nonatomic,strong)UIButton *leftBtn;
//背景图片
@property (strong, nonatomic)UIImageView *upViewBackgroudView;
//渐变色图片
@property (strong, nonatomic)UIImage *navigationBgImage;
//button背景
@property(nonatomic,strong)HeadItembgView *buttonsBgView;
//自定义ToolBar
@property(nonatomic,strong)XUToolbar *myToolbar;
@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.upView =[[UIView alloc] init];
        [self addSubview:self.upView];
        
 
        self.upViewBackgroudView =[[UIImageView alloc] init];
        self.upViewBackgroudView.image = self.navigationBgImage;
        self.upViewBackgroudView.contentMode =UIViewContentModeScaleToFill;
        [self.upView addSubview:self.upViewBackgroudView];
        
        
        self.Logo =[[UIImageView alloc] init];
        self.Logo.image =[UIImage imageNamed:@"logo white"];
        self.Logo.contentMode =UIViewContentModeScaleAspectFit;
        [self.upView addSubview:self.Logo];
        
        self.buttonsBgView =[[HeadItembgView alloc] init];
        self.buttonsBgView.delegate = self;
        [self.upView addSubview:self.buttonsBgView];
        
  
       
        self.myToolbar =[[XUToolbar  alloc] init];
        [self.upView addSubview:_myToolbar];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 40)];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(-3, -20, 0, 0);
        [leftButton setImage:[UIImage imageNamed:@"menu_white"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(openLeftMemu:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.tag = 99;
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        UIBarButtonItem *flexItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.myToolbar.items= @[leftItem,flexItem];

        
    }
    return self;
}


-(UIImage *)navigationBgImage
{
    if (!_navigationBgImage) {
        
        NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAV_PNG];
        _navigationBgImage =[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        
    }
    return _navigationBgImage;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat BoundHeight = self.bounds.size.height;
    CGFloat upHeight = BoundHeight *0.5 + 20;
    self.upView.frame = CGRectMake(0, 0, XScreenWidth,upHeight);
    self.upViewBackgroudView.frame = self.upView.frame;
  
 
    CGFloat topBarX = 0;
    CGFloat topBarY = 20;
    CGFloat topBarW = XScreenWidth;
    CGFloat topBarH = 44;
    self.myToolbar.frame = CGRectMake(topBarX, topBarY, topBarW, topBarH);
    
    CGFloat Logox = 0;
    CGFloat Logoy = 30;
    CGFloat Logow = XScreenWidth;
    CGFloat Logoh = upHeight * 0.2 ;
    self.Logo.frame = CGRectMake(Logox, Logoy, Logow, Logoh);
    
    CGFloat IBx = 0;
    CGFloat IBy = CGRectGetMaxY(self.Logo.frame) + ITEM_MARGIN;
    CGFloat IBw = XScreenWidth;
    CGFloat IBh = upHeight - IBy - 20;
    self.buttonsBgView.frame = CGRectMake(IBx, IBy, IBw,IBh);
   
}



#pragma mark ————HeadItembgViewDelegate
-(void)HeadItembgView:(HeadItembgView *)itemView WithItemtap:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(HomeHeaderView:WithItemtap:)]) {
        
        [self.delegate HomeHeaderView:self WithItemtap:sender];
        
    }
}


-(void)openLeftMemu:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(HomeHeaderView:WithItemtap:)]) {
        
        [self.delegate HomeHeaderView:self WithItemtap:sender];
        
    }
}



@end
