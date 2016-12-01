//
//  startSuccessViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/10.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "mergeSuccessViewController.h"

@interface mergeSuccessViewController ()
//图片
@property(nonatomic,strong)UIImageView *logoView;
//提示文字
@property(nonatomic,strong)UILabel *notiLab;
//立即体验
@property(nonatomic,strong)UIButton *startBtn;

@end

@implementation mergeSuccessViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page合并成功"];
    
}


-(void)viewDidAppear:(BOOL)animated{
   
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    [super viewWillDisappear:animated];
 
    [MobClick endLogPageView:@"page合并成功"];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self makeUI];
}



- (void)makeUI{
    
    self.title = @"合并成功";
    //图片
    CGFloat logoH = 80;
    CGFloat logoW = logoH;
    CGFloat logoX = (XScreenWidth - logoW) * 0.5;
    CGFloat logoY = 80;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, logoY, logoW, logoH)];
    [self.view addSubview:logoView];
    self.logoView = logoView;
    logoView.image =[UIImage imageNamed:@"TJ_success"];
    logoView.contentMode = UIViewContentModeScaleAspectFit;

    //提示文字
    CGFloat notiX = 20;
    CGFloat notiY = CGRectGetMaxY(logoView.frame) + 10;
    CGFloat notiW = XScreenWidth - notiX * 2;
    CGFloat notiH = 20;
    UILabel *notiLab = [UILabel labelWithFontsize:18 TextColor:XCOLOR_BLACK  TextAlignment:NSTextAlignmentCenter];
    notiLab.frame = CGRectMake(notiX, notiY, notiW, notiH);
    [self.view addSubview:notiLab];
    self.notiLab = notiLab;
    notiLab.text = @"账号合并成功";
    
    //立即体验
    CGFloat startX = notiX;
    CGFloat startY = CGRectGetMaxY(notiLab.frame) + 50;
    CGFloat startW = notiW;
    CGFloat startH = 50;
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, startW, startH)];
    [self.view addSubview:startBtn];
    [startBtn setTitle:@"立刻体验"  forState:UIControlStateNormal];
    [startBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    startBtn.backgroundColor  = XCOLOR_RED;
    [startBtn addTarget:self action:@selector(casestart:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.titleLabel.font = XFONT(16);
    startBtn.layer.cornerRadius = CORNER_RADIUS;
    self.startBtn = startBtn;
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn addTarget:self action:@selector(caseNoClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}


//立即体验
- (void)casestart:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)caseNoClick{
    
    KDClassLog(@"没反应");
    
}
-(void)dealloc{
    
    KDClassLog(@"合并成功  dealloc");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
