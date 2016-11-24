//
//  PhoneBeenViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/9.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PhoneBeenViewController.h"
#import "mergeAccountViewController.h"

@interface PhoneBeenViewController ()
@property(nonatomic,strong)UIButton *mergeBtn;
@property(nonatomic,strong)UIButton *phoneLoginBtn;
@property(nonatomic,strong)UILabel *notiLab;
@property(nonatomic,strong)UILabel *serviceLab;
@end

@implementation PhoneBeenViewController


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page绑定手机号"];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];

}



- (void)makeUI{
    
    self.title = @"手机号已存在";
  
    CGFloat notiX = 20;
    CGFloat notiY = 30;
    CGFloat notiW = XScreenWidth - notiX * 2;
    
    NSString *notiStr = @"此号码被注册，请选择\"合并账号\" 或直接登录";
    CGSize notiSize = [notiStr boundingRectWithSize:CGSizeMake(notiW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : XFONT(16)} context:nil].size;
     CGFloat notiH = notiSize.height;
    UILabel *notiLab = [UILabel labelWithFontsize:16 TextColor:XCOLOR_BLACK  TextAlignment:NSTextAlignmentLeft];
    notiLab.frame = CGRectMake(notiX, notiY, notiW, notiH);
    [self.view addSubview:notiLab];
    self.notiLab = notiLab;
    notiLab.numberOfLines = 0;
    notiLab.text = notiStr;
    
    
    CGFloat mergeX = notiX;
    CGFloat mergeY = CGRectGetMaxY(notiLab.frame) + 50;
    CGFloat mergeW = XScreenWidth - 2 * mergeX;
    CGFloat mergeH = 50;
    UIButton *mergeBtn = [[UIButton alloc] initWithFrame:CGRectMake(mergeX, mergeY, mergeW, mergeH)];
    [self.view addSubview:mergeBtn];
    [mergeBtn setTitle:@"合并账号"  forState:UIControlStateNormal];
    [mergeBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    mergeBtn.backgroundColor = XCOLOR_RED;
    [mergeBtn addTarget:self action:@selector(caseMerge:) forControlEvents:UIControlEventTouchUpInside];
    mergeBtn.titleLabel.font = XFONT(16);
    mergeBtn.layer.cornerRadius = CORNER_RADIUS;
    self.mergeBtn = mergeBtn;
    
    
    CGSize phoneSize = [@"手机登录" boundingRectWithSize:CGSizeMake(notiW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : XFONT(16)} context:nil].size;
    CGFloat phoneW = phoneSize.width;
    CGFloat phoneX = CGRectGetMaxX(mergeBtn.frame) - phoneW;
    CGFloat phoneY = CGRectGetMaxY(mergeBtn.frame) + 20;
    CGFloat phoneH = 30;
    UIButton *phoneLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneX, phoneY, phoneW, phoneH)];
    [self.view addSubview:phoneLoginBtn];
    [phoneLoginBtn setTitle:@"手机登录"  forState:UIControlStateNormal];
    [phoneLoginBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
     [phoneLoginBtn addTarget:self action:@selector(casePhoneLogin) forControlEvents:UIControlEventTouchUpInside];
     phoneLoginBtn.titleLabel.font = XFONT(16);
     self.phoneLoginBtn = phoneLoginBtn;
  
    
    CGFloat serX = 0;
    CGFloat serW = XScreenWidth - serX;
    NSString *serviceStr = @"致电myoffer客服热线：4000666522";
    CGSize serviceSize = [notiStr boundingRectWithSize:CGSizeMake(notiW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : XFONT(16)} context:nil].size;
    CGFloat serH = serviceSize.height;
    CGFloat serY = XScreenHeight - serH - XNav_Height - 35;
    UILabel *serviceLab = [UILabel labelWithFontsize:16 TextColor:XCOLOR_DARKGRAY  TextAlignment:NSTextAlignmentCenter];
    serviceLab.frame = CGRectMake(serX, serY, serW, serH);
    [self.view addSubview:serviceLab];
    self.serviceLab = serviceLab;
    serviceLab.text = serviceStr;
    serviceLab.numberOfLines = 0;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];

    
}


-(void)caseMerge:(UIButton *)sender{
    
    mergeAccountViewController *mergeVC = [[mergeAccountViewController alloc] init];
    mergeVC.mergePhone = self.mergePhone;
    [self.navigationController pushViewController:mergeVC animated:YES];
    
}


- (void)casePhoneLogin{

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
