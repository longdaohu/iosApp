//
//  startSuccessViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/10.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "mergeSuccessViewController.h"

@interface mergeSuccessViewController ()
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *notiLab;
@property(nonatomic,strong)UIButton *startBtn;

@end

@implementation mergeSuccessViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    [MobClick endLogPageView:@"page绑定手机号"];
    
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self makeUI];
}



- (void)makeUI{
    
    self.title = @"合并成功";
    
    CGFloat logoH = 80;
    CGFloat logoW = logoH;
    CGFloat logoX = (XScreenWidth - logoW) * 0.5;
    CGFloat logoY = 80;
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, logoY, logoW, logoH)];
    [self.view addSubview:logoView];
    self.logoView = logoView;
    logoView.image =[UIImage imageNamed:@"TJ_success"];
    logoView.contentMode = UIViewContentModeScaleAspectFit;

    
    CGFloat notiX = 20;
    CGFloat notiY = CGRectGetMaxY(logoView.frame) + 10;
    CGFloat notiW = XScreenWidth - notiX * 2;
    CGFloat notiH = 20;
    UILabel *notiLab = [UILabel labelWithFontsize:18 TextColor:XCOLOR_BLACK  TextAlignment:NSTextAlignmentCenter];
    notiLab.frame = CGRectMake(notiX, notiY, notiW, notiH);
    [self.view addSubview:notiLab];
    self.notiLab = notiLab;
    notiLab.text = @"账号合并成功";
    
    
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
 
}



- (void)casestart:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
